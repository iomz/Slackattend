module Slackattend
  class Backend
    KEEPALIVE_TIME = 15
    def initialize(app)
      @app = app
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, ping: KEEPALIVE_TIME)

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
          data = JSON.parse(event.data)
          name = data['name']
          action = data['action']
          unless CurrentMember.where(:name => name).empty?
            StatusLog.create(:name => name, :action => action)
            Slackattend.post_update({:name => name, :action => action})
            ws.send({ id: name, action: action}.to_json)
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
