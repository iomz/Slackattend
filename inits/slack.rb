# -*- coding: utf-8 -*-
require "slack"
require "open-uri"

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
  p "token is not valid"
  exit
else
  p "Slack API access successful"
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
  p "Creating #slackattend"
  res = Slack.channels_create(options = {:name => report_channel_name})
  pp res
  ch_id = res['channel']['id']
end
puts "Using ##{report_channel_name} channel id: #{ch_id}"

# Update users based on Slack userlist
res = Slack.users_list(options = {})
@members = []
res['members'].each do |u|
  username = u['name']
  avatar = u['profile']['image_original'] || u['profile']['image_192'] 
  unless excluded_users.include?(username)
    Status.create(name: username, status: "absent", updated_at: Time.now.to_f) if Status.where(:name => username).empty?
    Member.create(name: username, avatar: avatar)
    path = File.dirname(__FILE__)+"/../public/image/"+username+".jpg"
    open(avatar) {|f|
      File.open(path, "wb") do |file|
        file.puts f.read 
      end
    }
  end
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

