# -*- coding: utf-8 -*-
set :environment, :deveopment
set :haml, :escape_html => true
set :root, File.dirname(__FILE__)+"/../"

# Empty top page
get '/' do
  @title = Conf['title']
  members = Member.all
  statuses = {}
  @in_rooms = []
  @absents = []
  members.each do |m|
    statuses[m.name] = Status.order("id desc").find_by_name(m.name).status
    if statuses[m.name] == "in-room"
      @in_rooms << m
    else
      @absents << m
    end
  end
  haml :index
end

