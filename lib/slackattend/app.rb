module Slackattend
  class App < Sinatra::Base
    def app_root
      "#{env['rack.url_scheme']}://#{env['HTTP_HOST']}#{env['SCRIPT_NAME']}"
    end

    get '/' do
      @title = config[:title]
      @in_action = config[:in]
      @out_action = config[:out]
      @ins = []
      @outs = []
      Member.all.each do |m|
        case StatusLog.order("id desc").find_by_name(m.name).action
        when config[:in]
          @ins << m
        when config[:out]
          @outs << m
        end
      end
      haml :index
    end
  end
end
