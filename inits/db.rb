# -*- coding: utf-8 -*-
require 'sinatra'

set :database, Conf['db']
class Status < ActiveRecord::Base
end

class Member < ActiveRecord::Base
  validates :name, uniqueness: true
end

