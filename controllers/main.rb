# -*- coding: utf-8 -*-
configure do
  set :haml, :escape_html => true
  set :environment, :deveopment
end

# Empty top page
get '/' do
  @title = Conf['title']
  haml :index
end

