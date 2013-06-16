#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'json'
require 'open-uri'
require 'cgi'
require 'csv'
require 'logger'

require 'rubygems'
require 'twitter'

logger = Logger.new('/tmp/yulreftweet.log', 'daily')

settings = {}

data_url = "http://www.library.yorku.ca/libstats/reportReturn.do?&library_id=&location_id=&report_id=DataCSVReport"

t_end   = Time.now
t_start = t_end - 6*60 # Six minutes ago
# t_start = t_end - 24*60*60 # One day ago (lots of results for testing)

ugly_date_format = "%m/%d/%y %l:%M %p"
 
end_time = t_end.strftime(ugly_date_format)
start_time = t_start.strftime(ugly_date_format)

tweet_csv_url = data_url + "&date1=#{CGI.escape(start_time)}&date2=#{CGI.escape(end_time)}"

# STDERR.puts tweet_csv_url

begin
  settings = JSON.parse(File.read("config.json"))
rescue Exception => e
  STDERR.puts "No readable config.json settings file: #{e}"
  exit
end

Twitter.configure do |config|
  config.consumer_key = settings["consumer_key"]
  config.consumer_secret = settings["consumer_secret"]
  config.oauth_token = settings["access_token"]
  config.oauth_token_secret = settings["access_token_secret"]
end

csv = []

open(tweet_csv_url, "Cookie" => "login=#{settings["login_cookie"]}") do |f|
  unless f.status[0] == "200"
    logger.warn "Could not download data: status #{f.status}"
  else
    data = f.read
    if data == "\n"
      logger.info "Nothing to report"
      exit
    else
    csv = CSV.parse(data, {:headers => true, :header_converters => :symbol})
    end
  end
end

tweets_to_make = csv.size
delay = (300 / tweets_to_make).floor - 5

logger.info "Tweets: #{tweets_to_make}. Delay: #{delay} seconds"

csv.each do |row|
  next if row[:library_name] == "Scott Information" # Too busy!
  type = row[:question_type][0,1].to_i # Will be [1..5]
  type_string = "■ " * type + "□ " * (5 - type)
  tweet = "#{row[:library_name]} #{type_string} #{row[:time_spent]} (#{row[:question_id]})"
  logger.debug tweet
  begin
    Twitter.update(tweet)
  rescue Exception => e
    logger.error "Error: #{e}"
  end
  sleep delay
end

logger.close
