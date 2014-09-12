#!/usr/bin/ruby

require 'pathname'
require 'json'
require 'RMagick'
require 'pry'
require 'date'
include Magick

BASE_DIR = '/home/foscam'
MAX_AGE_DAYS = 3
SEARCH_DIR = BASE_DIR
WEB_IMG_DIR = '/var/www/foscollector/jpg/'
JSON_DIR = '/var/www/foscollector/'

collection = []

begin
  json_file = File.read(JSON_DIR + 'collection.json')
  collection = JSON.parse(json_file)
rescue
  puts "No existing collection data found"
end

collection_two_days = []

collection.each do |c|
  if c['date'].to_i > (DateTime.now.strftime('%s').to_i - (86400 * 2))
    collection_two_days << c
  end
end

collection_two_days.uniq!
collection_two_days.sort! { |x,y| y['date'].to_i <=> x['date'].to_i }

File.open(JSON_DIR + 'collection_two_days.json', "w+") do |file|
  puts "Writing file...(#{collection_two_days.count} records)"
  file.write(collection_two_days.to_json)
end