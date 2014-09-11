#!/usr/bin/env bash

source /usr/local/rvm/environments/ruby-2.1.2
ruby -v
ruby /var/www/foscollector/generate.rb
