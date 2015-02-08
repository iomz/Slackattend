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

    # Get an user name by user ID
    def get_user_name(user)
      return Slack.users_info({:user => user})["user"]["name"]
    end

    # Get a channel name by channel ID
    def get_channel_name(channel)
      return Slack.channels_info({:channel => channel})["channel"]["name"]
    end

    # Get a Slack channel ID by its name
    def get_channel_id_by_name(name)
      channel = Slack.channels_list['channels'].find{ |c| c['name'] == name } ||
        Slack.channels_create({:name => name})['channel']
      return channel['id']
    end 

    # Get a RTM client
    def get_rtm_client
      return Slack.realtime
    end

    # Update users based on Slack userlist
    def update_database
      Slack.users_list['members'].each do |m|
        user = m['name']
        avatar_image_url = m['profile']['image_original'] || m['profile']['image_192']
        unless config[:excluded_users].include?(user)
          m = CurrentMember.where(user: user).first_or_create
          if StatusLog.where(:user => user).empty?
            StatusLog.create(:user => user, :action =>:out)
            m.status = :out
          else
            m.status = StatusLog.order("id desc").find_by_user(user).action
          end
          m.user = user
          m.avatar_image_url = avatar_image_url
          m.save!
        else
          CurrentMember.where(user: user).destroy_all
        end
      end
    end

    def post_update(status)
      user = status[:user]
      action_name = Slackattend.config[status[:action]]
      report_template = Slackattend.config[:report_template] || DEFAULT_REPORT_TEMPLATE
      text = report_template % [user, action_name]
      post(text)
    end

    def post(text)
      Slack.chat_postMessage({
        :ts => Time.now.to_f,
        :channel => Slackattend.config[:report_channel_id],
        :text => text,
        :username => Slackattend.config[:bot_name] || DEAFAULT_BOT_NAME
      })
    end
  end

  extend SlackClient
end

