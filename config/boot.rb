require 'bundler'

Bundler.setup
Bundler.require :default, ENV['RACK_ENV']

require './app/offers_api'
