#!/usr/bin/env bash

bin/rails db:environment:set RAILS_ENV=development
bundle exec rake db:drop db:create db:migrate db:seed
