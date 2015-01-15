module Slackattend
  module SlackClient
    InvalidToken = Class.new(StandardError)

    # Default channel name to report the status update
    DEAFAULT_CHANNEL = 'slackattend'.freeze

    # Default channel name to report the status update
    DEAFAULT_BOT_NAME = 'slackattend'.freeze

    # Default literal template to post report on Slack
    DEFAULT_REPORT_TEMPLATE = %!%s %s!

    def setup
      Slack.configure{|conf| conf.token = Slackattend.config[:token]}
      raise InvalidToken if Slack.auth_test['ok'] == false
      Slackattend.config[:report_channel_id] = get_channel_id_by_name(Slackattend.config[:report_channel_name])
      update_database
    end

    # Get a Slack channel ID by its name
    def get_channel_id_by_name(name)
      channel = Slack.channels_list['channels'].find{ |c| c['name'] == name } ||
        Slack.channels_create({:name => name})['channel']
      return channel['id']
    end 

    # Update users based on Slack userlist
    def update_database
      Slack.users_list['members'].each do |m|
        name = m['name']
        avatar_image_url = m['profile']['image_original'] || m['profile']['image_192']
        unless config[:excluded_users].include?(name)
          CurrentMember.where(name: name).first_or_create do |m|
            m.name = name
            m.avatar_image_url = avatar_image_url
          end
          StatusLog.create(:name => name, :action => config[:out]) if StatusLog.where(:name => name).empty?
        end
      end
    end

    def post_update(status)
      name = status[:name]
      action = status[:action]
      report_template = Slackattend.config[:report_template] || DEFAULT_REPORT_TEMPLATE
      text = report_template % [name, action]
      p Slack.chat_postMessage({
        :ts => Time.now.to_f,
        :channel => Slackattend.config[:report_channel_id],
        :text => text,
        :username => Slackattend.config[:bot_name] || DEAFAULT_BOT_NAME
      })
    end
  end

  extend SlackClient
end

