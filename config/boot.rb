require 'bundler'

Bundler.setup
Bundler.require :default, ENV['RACK_ENV']

Mongoid.load!('./config/mongoid.yml', ENV['RACK_ENV'])

["../app", "../app/models"].each do |dir|
  Dir[File.expand_path("../#{dir}/*.rb", __FILE__)].each { |file| require file }
end
