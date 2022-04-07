FROM ruby:2.7.2

WORKDIR ~/

COPY . .

RUN gem install bundler && bundle install