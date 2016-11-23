FROM ruby:2.3.1
MAINTAINER Max Wofford <max@maxwofford.com>

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs graphviz

RUN mkdir /app
WORKDIR /app

ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle install -j4

ADD . /app
