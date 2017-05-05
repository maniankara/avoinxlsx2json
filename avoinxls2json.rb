#!/usr/bin/env ruby

# Converter for avoin data xlsx to json.
# This is a test project which parses data only from the testdata dirs.

require 'xlsx2json'
require 'json'

# Sample json object format:
# {"location" : [41.12, -71.34], "place" : "mannerheimintie", "date" : "2013-01-01", 
#  "NO" : 27, "NO2" : 37, "PM10" : 47, "SO2" : 57, "CO" : 67, "O3" : 77, "TRS" : 87, "POH" : "97"}
class Main
  
  XLSX_PATH = ARGV[0]
  JSON_PATH = ARGV[1]
  GEO_LOCATIONS = {
    "mannerheimintie" => "60.167999328,24.937329584",
    "vallila" => "60.18999924,24.953996184",
    "kallio" => "60.183832598,24.942829562",
    "leppvaara" => "60.2166658,24.8166634",
    "tikkurila" => "60.171999312,24.801496794" 
  }
  XLSX_SHEETS = {
    "NO" => 2,
    "NO2" => 4
  }

  attr_reader :json_path

  def initialize
  end
  
  def usage
    puts "Wrong commandline!"
    puts "Usage: "
    puts "    ./avoinxls2json.rb <path_to_xlsx> [path_to_json]"
    exit(-1)
  end
  
  def parse_args
    usage unless XLSX_PATH
    @json_path = "/tmp/a.json" unless JSON_PATH
      
  end
  
  def run
    parse_args
    u_json_objs = UniqueJsonObjects.new
    Xlsx2json::Transformer.execute XLSX_PATH, 2, @json_path, header_row_number: 4
    JSON.parse(File.open(json_path).read).each do |e|
      location = []
      e.each do |loc,val|
        next if loc == ("vuosi" or "kuukausi")
        u_json_objs.add("NO", loc, "#{e['vuosi']}-#{sprintf '%02d',e['kuukausi']}-01", val)  
      end
      
    end
    u_json_objs.dump.to_json
  end

  class UniqueJsonObjects
    attr_accessor :json_objs

    def initialize
      @json_objs = Hash.new
    end

    def add(param, place, date, value)
      if @json_objs["#{place}_#{date}"] 
        @json_objs["#{place}_#{date}"][param.to_sym] = value
      else
        @json_objs["#{place}_#{date}"] = {:place => place, :location => derive_location(place), :date => date, param.to_sym => value}
      end
    end

    def dump
      json_objs.values
    end

    def derive_location(place)
      GEO_LOCATIONS[place]
    end
  end
end

puts Main.new.run