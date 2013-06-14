#!/usr/bin/env ruby

require 'json'
require 'open-uri'

require 'rubygems'
require 'twitter'

settings = {}

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

open("http://www.miskatonic.org", "login" => settings["login_cookie"]) do |f|
  unless f.status[0] == "200"
    # !FIX
    puts f.status
    exit
  else
    puts f.read
  end
end

Twitter.update("First test tweet")
