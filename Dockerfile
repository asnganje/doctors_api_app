FROM ruby:3.3-alpine

RUN apk add --no-cache build-base postgresql-dev git

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY . .

ENV RAILS_ENV=production
ENV RACK_ENV=production

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]