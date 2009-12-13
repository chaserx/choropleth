#!/usr/local/bin/ruby -wKU

require "rubygems"
require "nokogiri"
require "fastercsv"

unemployment = {}
FasterCSV.foreach("unemployment09.csv") { |csv|
  full_fips = csv[1]+csv[2]
  rate = csv[8].strip!.to_f
  unemployment[full_fips] = rate 
  #unemployment.each { |key, value| puts "#{key}, #{value}"  }
}


doc = Nokogiri::XML(File.open("USA_Counties_with_FIPS_and_names.svg"))

paths = doc.xpath('//xmlns:path')

colors = ["#F1EEF6", "#D4B9DA", "#C994C7", "#DF65B0", "#DD1C77", "#980043"]

path_style = "font-size:12px;fill-rule:nonzero;stroke:#FFFFFF;stroke-opacity:1;
stroke-width:0.1;stroke-miterlimit:4;stroke-dasharray:none;stroke-linecap:butt;
marker-start:none;stroke-linejoin:bevel;fill:"

for path in paths
  #puts path['id']
  #puts rate = unemployment[path['id']]
  #puts path['style']
    while path['id'] =~ /\d/ do

      rate = unemployment[path['id']]
      
      if rate > 10
        color_class = 5
        #puts "I'm a 5"
      elsif rate > 8
        color_class = 4
        #puts "I'm a 4"
      elsif rate > 6
        color_class = 3
        #puts "I'm a 3"
      elsif rate > 4
        color_class = 2
        #puts "I'm a 2"
      elsif rate > 2
        color_class = 1
        #puts "I'm a 1"
      elsif rate == 0
        color_class = 0
        #puts "I'm a 0"
      else
        color_class = 0
        #puts "Into the Else"
      end
    
      color = colors[color_class.to_i]
      path['style'] = path_style + color

    end
    
end

outfile = File.new("outfile.svg", "w")
outfile << doc.to_s

