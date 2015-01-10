# -*- coding: utf-8 -*-
require 'sinatra'
require "sinatra/activerecord"
require 'slack'
require 'pp'

class Status < ActiveRecord::Base
end

set :database, Conf['db']
set :haml, :escape_html => true
set :environment, :deveopment

# init
token = Conf['token']
report_channel_name = Conf['report_channel_name']
excluded_users = Conf['excluded_users']

Slack.configure do |config|
  config.token = token
end

# Check the token validity
res = Slack.auth_test
if res['ok'] == false
  puts "token is not valid"
  exit
else
  puts "Slack API access successful"
end

# Check slackattend channel, create one if none matched
ch_id = nil
channels = Slack.channels_list['channels']
channels.each do |c|
  if c['name'] == report_channel_name
    ch_id = c['id']
  end
end
if ch_id.nil?
  puts "Creating #slackattend"
  res = Slack.channels_create(options = {:name => report_channel_name})
  pp res
  ch_id = res['channel']['id']
end
puts "Using ##{report_channel_name} channel id: #{ch_id}"

# Update users based on Slack userlist
res = Slack.users_list(options = {})
res['members'].each do |u|
  username = u['name']
  Status.create(name: username, status: "退勤", updated_at: Time.now.to_f) unless excluded_users.include?(username)
end

=begin
msg = "Test via API"
res = Slack.chat_postMessage(options = {
  :ts => Time.now.to_f,
  :channel => slack_ch,
  :text => msg,
  :username => 'slackattend'
})
pp res
=end

# Empty top page
get '/' do
  @title = Conf['title']
  @statuses = Status.all
  pp @statuses
  haml :index
end

