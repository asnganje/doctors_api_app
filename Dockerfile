FROM ruby:3.3-alpine

# Install dependencies needed for native gems
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    git \
    yaml-dev \
    readline-dev \
    bash

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install --without development test

COPY . .

ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV PORT=8080  # Ensure Railway port matches Puma

EXPOSE 8080

CMD ["sh", "-c", "bundle exec rails db:migrate && bundle exec puma -C config/puma.rb -b 0.0.0.0 -p $PORT"]