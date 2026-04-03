# syntax=docker/dockerfile:1.7
# ─────────────────────────────────────────────────────────────────────────────
# Multi-stage Dockerfile
#
# Targets
#   development  – all gem groups installed; used by docker compose
#   production   – lean runtime image, production gems only
#
# Quick-start (see docker-compose.yml for more commands)
#   docker compose up                                 # http://localhost:1843
#   docker compose run --rm web bin/rails console
#   docker compose run --rm web bundle exec rspec
# ─────────────────────────────────────────────────────────────────────────────

ARG RUBY_VERSION=3.4.5
ARG BUNDLER_VERSION=2.4.7

# ── Base: system packages shared by every stage ───────────────────────────────
FROM ruby:${RUBY_VERSION}-alpine AS base

ARG BUNDLER_VERSION

# build-base  – C toolchain required by native gem extensions
# sqlite-dev  – SQLite headers for the sqlite3 gem
# nodejs      – required by the asset pipeline / importmap
# tzdata      – timezone data used by ActiveSupport
# bash        – required by bin/docker-entrypoint and bin/ wrappers
RUN apk add --no-cache \
      build-base \
      linux-headers \
      sqlite-dev \
      yaml-dev \
      tzdata \
      bash && \
    gem install bundler:${BUNDLER_VERSION} --no-document

WORKDIR /app

# Copy manifests before app code so Docker can cache the bundle install
# layer independently of application code changes.
COPY Gemfile Gemfile.lock ./

# ── Development: all gem groups, source code mounted as a bind volume ─────────
FROM base AS development

ENV RAILS_ENV=development \
    BUNDLE_PATH=/usr/local/bundle

# Install all groups (development + test included).
RUN bundle install --jobs 4

COPY bin/docker-entrypoint /usr/local/bin/docker-entrypoint
RUN chmod +x /usr/local/bin/docker-entrypoint

HEALTHCHECK --interval=10s --timeout=5s --start-period=40s --retries=5 \
  CMD wget -qO- http://localhost:1843/up || exit 1

ENTRYPOINT ["docker-entrypoint"]
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "1843"]

# ── Build: assemble and precompile for production ─────────────────────────────
FROM base AS build

ENV RAILS_ENV=production \
    BUNDLE_PATH=/usr/local/bundle \
    # Allows asset precompilation without a real SECRET_KEY_BASE at build time.
    SECRET_KEY_BASE_DUMMY=1

RUN bundle config set --local without "development test" && \
    bundle install --jobs 4

COPY . .

# Warm the bootsnap cache to cut boot time in production.
RUN bundle exec bootsnap precompile app/ lib/

# ── Production: minimal runtime image ─────────────────────────────────────────
FROM ruby:${RUBY_VERSION}-alpine AS production

# Runtime-only: no build-base, no header packages.
RUN apk add --no-cache \
      sqlite-libs \
      tzdata \
      bash

WORKDIR /app

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app /app

ENV RAILS_ENV=production \
    BUNDLE_PATH=/usr/local/bundle \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true

EXPOSE 80
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "80"]
