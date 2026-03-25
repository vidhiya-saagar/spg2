# syntax=docker/dockerfile:1
# =============================================================================
# SPG2 – Multi-stage Dockerfile
#
# Targets
#   development  – full gem set, live-reload friendly (used by docker-compose)
#   builder      – compiles production gems + bootsnap cache
#   production   – lean runtime image shipped to Fly.io / any registry
# =============================================================================

ARG RUBY_VERSION=3.4.5

# ---------------------------------------------------------------------------
# base – shared OS packages for all stages
# ---------------------------------------------------------------------------
FROM ruby:${RUBY_VERSION}-alpine AS base

# build-base  : gcc/make needed to compile native gem extensions
# sqlite-dev  : headers for the sqlite3 gem
# nodejs      : required by importmap / tailwindcss-rails at boot
# tzdata      : timezone support used by ActiveSupport
# libffi-dev  : required by llhttp-ffi (transitive dep of contentful → http)
# yaml-dev    : required by psych (Ruby YAML parser)
RUN apk --no-cache add \
      build-base \
      sqlite-dev \
      nodejs \
      tzdata \
      libffi-dev \
      yaml-dev

WORKDIR /app

# ---------------------------------------------------------------------------
# development – all gems (dev + test included), mounted source code
# ---------------------------------------------------------------------------
FROM base AS development

COPY Gemfile Gemfile.lock ./

# Install every gem group into the default system path so that a volume-mount
# of the source code (`.:/app`) does not overwrite the installed gems.
RUN gem install bundler && \
    bundle install --jobs 4

COPY . .

ENV RAILS_ENV=development \
    PORT=1843

EXPOSE 1843

CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "1843"]

# ---------------------------------------------------------------------------
# builder – production-only gems + precompiled bootsnap cache
# ---------------------------------------------------------------------------
FROM base AS builder

COPY Gemfile Gemfile.lock ./

# Install gems to the default system path (/usr/local/bundle).
# We do NOT use --local path vendor/bundle here because parallel gem
# compilation can fail when a native-extension gem (e.g. llhttp-ffi) tries
# to load a dependency (ffi) that hasn't finished installing yet.
RUN gem install bundler && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 1

COPY . .

# Warm up bootsnap's load-path cache so the first request isn't slow
RUN bundle exec bootsnap precompile app/ lib/

# ---------------------------------------------------------------------------
# production – minimal runtime, no build tooling
# ---------------------------------------------------------------------------
FROM ruby:${RUBY_VERSION}-alpine AS production

# Runtime-only native libs (no -dev headers needed)
RUN apk --no-cache add \
      sqlite-libs \
      nodejs \
      tzdata \
      libffi \
      yaml

WORKDIR /app

# Copy installed gems from the builder's system gem path
COPY --from=builder /usr/local/bundle /usr/local/bundle
# Copy the application code
COPY --from=builder /app /app

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    PORT=80

EXPOSE 80

# Prepare the database then hand off to the main process
ENTRYPOINT ["/app/bin/docker-entrypoint"]
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "80"]
