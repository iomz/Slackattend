%w(
  faye/websocket
  haml
  json
  open-uri
  puma
  sinatra/activerecord
  sinatra/base
  slack
  yaml
).each { |lib| require lib }

%w(
  core
  status_log
  current_member
  slack_client
  backend
).each { |name| require_dependency File.expand_path("../slackattend/#{name}", __FILE__) }

module Slackattend
  class App < Sinatra::Base
    register Sinatra::ActiveRecordExtension
    set :database, Slackattend.config[:database]
    set :root, File.expand_path("../../", __FILE__)

    get '/' do
      @title = Slackattend.config[:title]
      @in_action = Slackattend.config[:in]
      @out_action = Slackattend.config[:out]
      @ins = []
      @outs = []
      CurrentMember.all.each do |m|
        case StatusLog.order("id desc").find_by_name(m.name).action
        when Slackattend.config[:in]
          @ins << m
        when Slackattend.config[:out]
          @outs << m
        end
      end
      haml :index
    end
  end
end

