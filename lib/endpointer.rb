require "endpointer/version"
require "endpointer/resource_parser"
require "endpointer/app_creator"
require "endpointer/errors/invalid_arguments_error"
require 'endpointer/configuration'

module Endpointer
  class << self
    def run(config)
      @configuration = config
      app.run!
    end

    def app
      Cacher.new(configuration.cache_dir).invalidate if configuration.invalidate
      AppCreator.new.create(configuration)
    end

    def configure
      yield(configuration) if block_given?
      self
    end

    private

    def configuration
      @configuration ||= Configuration.new
    end
  end
end
