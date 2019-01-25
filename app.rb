require 'bundler'
Bundler.require

$:.unshift File.expand_path('./../lib', __FILE__)
require 'views/index.rb'

Index.new.perform