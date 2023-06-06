# We are creating a multi-stage Docker build. 
# This is useful for creating lighter production images as we can exclude dependencies and files not necessary for running the application.

# Base stage
# We're starting from an official Ruby Docker image. It is based on Alpine, which is a lightweight Linux distribution.
FROM ruby:3.2.1-alpine AS base

# All the operations following this instruction will be performed in the /app directory in the Docker image filesystem.
WORKDIR /app

# Run is used to execute a command during the building of a Docker image.
# apk is a package management tool included in Alpine Linux. --update means update the local package database before installing the packages.
# build-base is a meta-package that installs GCC, libc, and other compilation tools.
# sqlite-dev installs the SQLite development files.
# nodejs is the JavaScript runtime.
# tzdata is time zone data, which is often required by various Ruby libraries.
RUN apk --update add \
    build-base \
    sqlite-dev \
    nodejs \
    tzdata

# Copies the Gemfile and Gemfile.lock from your local filesystem into the Docker image.
# This is needed for the next step, installing Ruby dependencies.
COPY Gemfile Gemfile.lock ./

# Bundle install is a command to install Ruby dependencies. 
# Here, we're also configuring bundler to install the gems locally into vendor/bundle (for easier copying between stages)
# and we're setting it up to be deployment-ready.
# --jobs=4 means use 4 workers for parallel installation.
RUN gem install bundler && \
    bundle config set path 'vendor/bundle' && \
    bundle config set deployment 'true' && \
    bundle install --jobs=4 --without development test

# Builder stage
# This stage takes the previous stage as its base.
# It's used to build our application without polluting the final stage with unnecessary files and dependencies.
FROM base AS builder

# Copy all files from the local source directory to the WORKDIR in the image.
COPY . .

# Final stage
# This is the stage that will be used to run the application.
# It starts from the base stage and includes only the necessary files.
FROM base

# Add additional dependencies that are only required for running the application.
RUN apk --update add \
    sqlite-libs \
    nodejs

# Copy necessary files and directories from the builder stage to the final image.
COPY --from=builder /app /app

# This environment variable is used to set the Rails environment to production.
ENV RAILS_ENV=production

# The CMD instruction defines the command that will be run when a container is started from the Docker image.
# Here, we're starting the Rails server on port 80 and binding it to all interfaces.
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "80"]
