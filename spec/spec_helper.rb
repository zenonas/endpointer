$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
SimpleCov.start do
  add_filter "/spec"
end

require 'endpointer'
require 'pry'
require 'webmock/rspec'
