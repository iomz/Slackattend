%w(
  addressable/uri
  faye/websocket
  haml
  json
  natto
  nokogiri
  open-uri
  puma
  sinatra/activerecord
  sinatra/base
  slack
  time
  yaml
).each { |lib| require lib }

%w(
  status_log
  current_member
  sojourn_time
  attendance_count
  core
  slack_client
  websocket_handler
  sentiment_analyzer
).each { |name| require_dependency File.expand_path("../slackattend/#{name}", __FILE__) }

module Slackattend
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :database, Slackattend.config[:database]
    set :root, File.expand_path("../../", __FILE__)

    get '/' do
      @title = Slackattend.config[:title]
      @in_action = Slackattend.config[:in]
      @away_action = Slackattend.config[:away]
      @out_action = Slackattend.config[:out]
      @ins = []
      @aways = []
      @outs = []
      CurrentMember.all.each do |m|
        case StatusLog.order("id desc").find_by_user(m.user).action
        when "in"
          @ins << m
        when "out"
          @outs << m
        else
          p StatusLog.order("id desc").find_by_user(m.user).action 
        end
      end
      haml :index
    end
  end
end

