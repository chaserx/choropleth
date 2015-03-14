#!/usr/local/bin/ruby -wKU

require "nokogiri"
require 'csv'

# Step 1 - Pull the county specific data from a csv file and county code and unemployment rate into a hash
unemployment = {}
CSV.foreach(File.expand_path('data/cleaned/unemployment14.csv')) do |csv|
  full_fips = csv[1]+csv[2]
  rate = csv[8].strip.to_f
  unemployment[full_fips] = rate
end

# Step 2 - Open the blank map with Nokogiri
doc = Nokogiri::XML(File.open(File.expand_path('svg/USA_Counties_with_FIPS_and_names.svg')))

# pull paths into a nokogiri node set
# this took hours to figure out that you need to have the xmlns part in place. doesn't appear to work without.
paths = doc.xpath('//xmlns:path')

# Step 3 - recolor the counties based on the county's unemployment rate
# colors = ["#F1EEF6", "#D4B9DA", "#C994C7", "#DF65B0", "#DD1C77", "#980043"]

colors = ["#fff5eb", "#fee6ce", "#fdd0a2", "#fdae6b", "#fd8d3c", "#f16913",
          "#d94801", "#a63603", "#7f2704"]

path_style = "font-size:12px;fill-rule:nonzero;stroke:#FFFFFF;stroke-opacity:1;
stroke-width:0.1;stroke-miterlimit:4;stroke-dasharray:none;stroke-linecap:butt;
marker-start:none;stroke-linejoin:bevel;fill:"

paths.each do |path|
  # a little debug output
  puts path['id']
  rate = unemployment[path['id']]
  puts rate

  next if path['id'].match(/[A-Za-z]/)

  rate = 0 if rate.nil?

  if rate > 10
    path['style'] = path_style + '#000000'
  elsif rate > 9
    path['style'] = path_style + colors[8]
  elsif rate > 8
    path['style'] = path_style + colors[7]
  elsif rate > 7
    path['style'] = path_style + colors[6]
  elsif rate > 6
    path['style'] = path_style + colors[5]
  elsif rate > 5
    path['style'] = path_style + colors[4]
  elsif rate > 4
    path['style'] = path_style + colors[3]
  elsif rate > 3
    path['style'] = path_style + colors[2]
  elsif rate > 2
    path['style'] = path_style + colors[1]
  elsif rate > 1
    path['style'] = path_style + colors[0]
  elsif rate < 1
    path['style'] = path_style + '#ffffff'
  else
    path['style'] = path['style']
  end

  # debug: puts the style
  puts path['style']
end

# Step 4 - create a new file and push the modified svg structure into the new outfile
outfile = File.new('unemployment14.svg', 'w')
outfile << doc.to_s

