# -*- coding: utf-8 -*-
module Slackattend
  module SlackClient
    InvalidToken = Class.new(StandardError)

    # Default channel name to report the status update
    DEAFAULT_CHANNEL = 'slackattend'

    def setup(token, channel=nil)
      Slack.configure{|conf| conf.token = token}
      raise InvalidToken if Slack.auth_test['ok'] == false
      self.report_channel_name = channel || DEAFAULT_CHANNEL
      self.report_channel_id = get_channel_id_by_name
    end

    def get_channel_id_by_name(name)
      channel = Slack.channels_list['channels'].find{ |c| c['name'] == name } ||
        Slack.channels_create({:name => name})['channel']
      return channel['id']
    end 
  end
end

# Update users based on Slack userlist
res = Slack.users_list(options = {})
res['members'].each do |u|
  username = u['name']
  avatar = u['profile']['image_original'] || u['profile']['image_192'] 
  unless excluded_users.include?(username)
    Status.create(name: username, status: "退勤") if Status.where(:name => username).empty?
    Member.create(name: username, avatar: avatar)
  end
end

