#!/usr/local/bin/ruby -wKU

require 'csv'

# remove
csv_outfile = File.open(File.expand_path('data/cleaned/unemployment14.csv'), 'w')
file = File.readlines(File.expand_path('data/raw/2014/laucntycur14.txt')).slice(6..-6)
file.each do |line|
  csv_outfile << line.split('|').each(&:strip!).to_csv
end
