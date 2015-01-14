# -*- coding: utf-8 -*-
require 'faye/websocket'
require 'json'

module Slackattend
  # rack middleware
  class Backend
    KEEPALIVE_MINS = 15

    def initialize(app)
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_MINS)

        ws.on(:open) do |event|
          p [:open, ws.object_id]
          @clients << ws
          ws.send({ you: ws.object_id }.to_json)
          @clients.each do |client|
            client.send({ count: @clients.size }.to_json)
          end
        end

        ws.on(:message) do |event|
          p [:message, event.data]
          user, action = event.data.split()
          status = (action == "enter") ? "出勤" : "退勤"
          unless Member.where(:name => user).empty?
            Status.create(:name => user, :status => status, :updated_at => Time.now.to_f)
            event = user + "さんが" + status + "しました。"
            res = Slack.chat_postMessage(options = {
              :ts => Time.now.to_f,
              :channel => Conf['chid'],
              :text => event,
              :username => 'slackattend'
            })
            pp res
            ws.send(user+":"+action)
          end
        end

        ws.on(:close) do |event|
          p [:close, ws.object_id, event.code]
          @clients.delete(ws)
          @clients.each do |client|
            client.send({ count: @clients.size }.to_json)
          end
          ws = nil
        end
        ws.rack_response
      else
        @app.call(env)
      end
    end
  end
end
