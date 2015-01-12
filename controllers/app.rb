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
      ws.send(user+":"+action)
    end

    ws.on(:close) do |event|
      puts 'On Close'
    end

    ws.rack_response
  else
    @title = Conf['title']
    members = Member.all
    statuses = {}
    @in_rooms = []
    @absents = []
    members.each do |m|
      statuses[m.name] = Status.order("id desc").find_by_name(m.name).status
      if statuses[m.name] == "出勤"
        @in_rooms << m
      else
        @absents << m
      end
    end
    haml :index
  end
end

