# TODO: clean up 
require 'bundler/setup'
require 'faye/websocket'
require 'haml'
require 'rack'
require 'rubygems'
require "sinatra/activerecord"
require 'sinatra/content_for'
require 'pp'

require File.dirname(__FILE__)+'/bootstrap'
Bootstrap.init :inits, :controllers, :helpers

Faye::WebSocket.load_adapter('thin')

$stdout.sync = true #if development?
run Sinatra::Application

