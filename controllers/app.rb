# -*- coding: utf-8 -*-
set :environment, :deveopment
set :haml, :escape_html => true
set :root, File.dirname(__FILE__)+"/../"

# Empty top page
get '/' do
  if Faye::WebSocket.websocket?(request.env)
    ws = Faye::WebSocket.new(request.env)
    ws.on(:open) do |event|
      puts 'On Open'
    end

    ws.on(:message) do |msg|
      user, action = msg.data.split()
      status = (action == "enter") ? "出勤" : "退勤"
      unless Member.where(:name => user).empty?
        Status.create(:name => user, :status => status, :updated_at => Time.now.to_f)
        msg = user + "さんが" + status + "しました。"
        res = Slack.chat_postMessage(options = {
          :ts => Time.now.to_f,
          :channel => Conf['chid'],
          :text => msg,
          :username => 'slackattend'
        })
        pp res
        ws.send(user+":"+action)
      end
    end

    ws.on(:close) do |event|
      puts 'On Close'
    end

    ws.rack_response
  else
    @title = Conf['title']
    @in_rooms = []
    @absents = []
    Member.all.each do |m|
      if Status.order("id desc").find_by_name(m.name).status == "出勤"
        @in_rooms << m
      else
        @absents << m
      end
    end
    haml :index
  end
end

