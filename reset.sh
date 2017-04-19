#!/usr/bin/env bash

RAILS_ENV=development bundle exec rake db:drop db:create db:migrate db:seed
