# -*- coding: utf-8 -*-
set :environment, :deveopment
set :haml, :escape_html => true
set :root, File.dirname(__FILE__)+"/../"

# Empty top page
get '/' do
  @title = Conf['title']
  @statuses = Status.where(:name => "iomz")
  @members = Member.all
  haml :index
end

