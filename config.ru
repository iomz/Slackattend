$stdout.sync = true #if development?
require 'bundler/setup'
require 'haml'
require 'json'
require 'sass'
require 'rack'
require 'rubygems'
require 'sinatra'
require 'sinatra/cookies'
require 'sinatra/reloader' #if development?
require 'sinatra/content_for'
require 'uri'
require 'yaml'

require File.dirname(__FILE__)+'/bootstrap'
Bootstrap.init :inits, :helpers, :controllers

run Sinatra::Application

