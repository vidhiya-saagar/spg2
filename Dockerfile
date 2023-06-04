# Base stage
FROM ruby:3.2.1-alpine AS base

WORKDIR /app

RUN apk --update add \
    build-base \
    sqlite-dev \
    nodejs \
    tzdata

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && \
    bundle config set path 'vendor/bundle' && \
    bundle config set deployment 'true' && \
    bundle install --jobs=4 --without development test

# Builder stage
FROM base AS builder

COPY . .

# Final stage
FROM base

RUN apk --update add \
    sqlite-libs \
    nodejs

COPY --from=builder /app /app

ENV RAILS_ENV=production

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "80"]
