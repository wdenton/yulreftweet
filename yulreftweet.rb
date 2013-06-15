#!/usr/bin/env ruby

require 'json'
require 'open-uri'
require 'cgi'

require 'rubygems'
require 'twitter'

settings = {}

data_url = "http://www.library.yorku.ca/libstats/reportReturn.do?&library_id=&location_id=&report_id=DataCSVReport"
# ?date1=6%2F14%2F13+9%3A00+AM&date2=6%2F14%2F13+11%3A55+AM

t_end   = Time.now
t_start = t_end - 10*60 # Ten minutes ago

ugly_date_format = "%m/%d/%y %l:%M %p"
 
end_time = t_end.strftime(ugly_date_format)
start_time = t_start.strftime(ugly_date_format)

# puts CGI.unescape("6%2F14%2F13+9%3A00 AM")
# puts CGI.escape(start_time)

tweet_csv_url = data_url + "&date1=#{CGI.escape(start_time)}&date2=#{CGI.escape(end_time)}"

puts tweet_csv_url

begin
  settings = JSON.parse(File.read("config.json"))
rescue Exception => e
  puts "No readable config.json settings file: #{e}"
  exit
end

Twitter.configure do |config|
  config.consumer_key = settings["consumer_key"]
  config.consumer_secret = settings["consumer_secret"]
  config.oauth_token = settings["access_token"]
  config.oauth_token_secret = settings["access_token_secret"]
end

open(tweet_csv_url, "login" => settings["login_cookie"]) do |f|
  unless f.status[0] == "200"
    # !FIX
    puts f.status
    exit
  else
    puts f.read
  end
end

# Twitter.update("First test tweet")
