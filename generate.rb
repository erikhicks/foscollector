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

puts DateTime.now.to_s
puts "Starting..."


begin
  json_file = File.read(JSON_DIR + 'collection.json')
  collection = JSON.parse(json_file)
rescue
  puts "No valid collection data found"
  collection = []
end

files = Dir.glob("#{SEARCH_DIR}/**/*.jpg")
count_added = 0

files.each do |file|
  name = Pathname.new(file).basename
  date = name.to_s.match(/\d{8}-\d{6}/).to_s.gsub('-',' ')
  age_days = (DateTime.now.to_time - DateTime.parse(date).to_time) / 86400
  date = DateTime.parse(date).strftime('%s').to_i

  if age_days > MAX_AGE_DAYS
#    puts "Too old to process: #{file}"
    next
  end

  if collection.select {|c| c['name'] == name.to_s}.count > 0
#    puts "Already in collection: #{file}"
    next
  end

  begin
    img_orig = ImageList.new(file)
  rescue
    next
  end

  img_new = img_orig.resize(200, 112)
  puts "Writing #{name.to_s}..."

  img_orig.write(WEB_IMG_DIR + name.to_s)
  img_new.write(WEB_IMG_DIR + '/thumb/' + name.to_s)
  img_new.destroy!
  img_orig.destroy!

  obj = {}
  obj['name'] = name.to_s
  obj['date'] = date
  
  collection << obj
  count_added += 1

  #File.delete(file)
end

collection.uniq!
collection.sort! { |x,y| y['date'].to_i <=> x['date'].to_i }

File.open(JSON_DIR + 'collection.json', "w+") do |file|
  puts "Writing file...(#{collection.count} records)"
  file.write(collection.to_json)
end

puts "Added #{count_added} new images"
