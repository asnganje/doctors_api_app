# syntax=docker/dockerfile:1

# Use Ruby 3.3.7
FROM ruby:3.3.7-slim AS base

# Working directory
WORKDIR /app

# Install OS dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    curl \
    libpq-dev \
    libyaml-dev \
    pkg-config \
    libjemalloc2 \
    libvips \
    postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Set Rails environment
ENV RAILS_ENV=production \
    BUNDLE_DEPLOYMENT=1 \
    BUNDLE_PATH=/usr/local/bundle \
    BUNDLE_WITHOUT="development:test"

# Copy Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the app
COPY . .

# Make bin/ files executable
RUN chmod +x bin/* && sed -i "s/\r$//g" bin/* && sed -i 's/ruby\.exe$/ruby/' bin/*

# Expose Rails default port
EXPOSE 3000

# Non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails

# Start Rails at runtime: first prepare DB, then run server
CMD ["sh", "-c", "until bin/rails db:prepare; do echo 'Waiting for DB...'; sleep 2; done && bin/rails server -b 0.0.0.0"]