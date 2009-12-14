#!/usr/local/bin/ruby -wKU

require "rubygems"
require "nokogiri"
require "fastercsv"

# 12.12.09
# Chase Southard
# chase {dot} southard [at] gmail {dot} com

# About
# This is a rework of Nathan Yau's post on his blog Flowing Data entitled "How to Make a US County Thematic Map Using Free Tools."
# http://flowingdata.com/2009/11/12/how-to-make-a-us-county-thematic-map-using-free-tools/


# Step 1 - Pull the county specific data from a csv file and county code and unemployment rate into a hash
unemployment = {}
FasterCSV.foreach("unemployment09.csv") { |csv|
  full_fips = csv[1]+csv[2]
  rate = csv[8].strip!.to_f
  unemployment[full_fips] = rate 
}

# Step 2 - Open the blank map with Nokogiri
doc = Nokogiri::XML(File.open("USA_Counties_with_FIPS_and_names.svg"))

# pull paths into a nokogiri node set
# this took hours to figure out that you need to have the xmlns part in place. doesn't appear to work without.
paths = doc.xpath('//xmlns:path')

# Step 3 - recolor the counties based on the county's unemployment rate
colors = ["#F1EEF6", "#D4B9DA", "#C994C7", "#DF65B0", "#DD1C77", "#980043"]

path_style = "font-size:12px;fill-rule:nonzero;stroke:#FFFFFF;stroke-opacity:1;
stroke-width:0.1;stroke-miterlimit:4;stroke-dasharray:none;stroke-linecap:butt;
marker-start:none;stroke-linejoin:bevel;fill:"

for path in paths
      
      #a little debug output
      puts path['id']
      rate = unemployment[path['id']]
      puts rate
    
      if rate == nil then rate = 0 end
    
      if rate > 10
        path['style'] = path_style + colors[5]
      elsif rate > 8
        path['style'] = path_style + colors[4]
      elsif rate > 6
        path['style'] = path_style + colors[3]
      elsif rate > 4
        path['style'] = path_style + colors[2]
      elsif rate > 2
        path['style'] = path_style + colors[1]
      #elsif rate == 0
        #color_class = 0
        #puts "I'm a 0"
        #path['style'] = path_style + colors[0]
      else
        path['style'] = path['style']
      end
      
      # debug: puts the style 
      puts path['style']    
end

# Step 4 - create a new file and push the modified svg structure into the new outfile
outfile = File.new("outfile.svg", "w")
outfile << doc.to_s

