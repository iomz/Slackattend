# TODO: clean up 
require 'bundler/setup'
require 'haml'
require 'rack'
require 'rubygems'
require 'slack'

require File.dirname(__FILE__)+'/bootstrap'
Bootstrap.init :helpers

$stdout.sync = true #if development?
run Sinatra::Application

