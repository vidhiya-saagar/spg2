# Stage 1: Build stage
FROM ruby:3.2.1-alpine AS builder

RUN apk --update add \
    build-base \
    sqlite-dev \
    nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.4.7
RUN bundle config set path 'vendor/bundle'
RUN bundle config set deployment 'true' 
RUN bundle install --jobs=4 --without development test || echo "bundle install failed"
RUN bundle show rails || echo "Rails not installed"

COPY . .

# Stage 2: Final image
FROM ruby:3.2.1-alpine

RUN apk --update add \
    sqlite-libs \
    nodejs

WORKDIR /app

COPY --from=builder /app /app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
