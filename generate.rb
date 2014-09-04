#!/usr/bin/ruby

require 'pathname'
require 'json'
require 'RMagick'
require 'pry'
include Magick

BASE_DIR = '/Users/erikhicks/code/foscam'

SEARCH_DIR = BASE_DIR + '/'
WEB_IMG_DIR = BASE_DIR + '/jpg/'
JSON_DIR = BASE_DIR + '/'

puts "Starting..."


begin
  json_file = File.read(JSON_DIR + 'collection.json')
  collection = JSON.parse(collection)
rescue
  collection = []
end

files = Dir.glob("#{SEARCH_DIR}/**/*.jpg")

files.each do |file|
  name = Pathname.new(file).basename
  puts name

  img_orig = ImageList.new(file)
  img_new = img_orig.resize(200, 112)

  img_orig.write(WEB_IMG_DIR + name.to_s)
  img_new.write(WEB_IMG_DIR + '/thumb/' + name.to_s)

  date = File::Stat.new(file).ctime

  collection << {
    name: name,
    date: date
  }
end


collection.uniq!

File.open(JSON_DIR + 'collection.json', "w") do |file|
  file.write(collection.reverse.to_json)
end
