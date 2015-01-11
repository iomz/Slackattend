# -*- coding: utf-8 -*-
require 'sinatra'

set :database, Conf['db']
class Status < ActiveRecord::Base
end

# TODO: Overwrite a member when whose avatar changed
class Member < ActiveRecord::Base
  validates :name, uniqueness: true
  validates :avatar, uniqueness: true
end

