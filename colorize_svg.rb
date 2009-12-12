#!/usr/local/bin/ruby -wKU

require "rubygems"
require "nokogiri"
require "fastercsv"

unemployment = {}
FasterCSV.foreach("/Users/rcsouthard/Desktop/dataviz/unemployment09.csv") { |csv|
  full_fips = csv[1]+csv[2]
  rate = csv[8].strip!.to_f
  unemployment[full_fips] = rate 
  unemployment.each { |key, value| puts "#{key}, #{value}"  }
}

  
