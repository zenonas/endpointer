require "endpointer/version"
require "endpointer/argument_parser"
require "endpointer/app_creator"
require "endpointer/errors/invalid_arguments_error"

module Endpointer

  CACHE_DIR = File.join(Dir.tmpdir, "endpointer_cache")

  def self.run(arguments)
    app(arguments).run!
  end

  def self.app(arguments)
    argument_parser = ArgumentParser.new(arguments)
    raise Errors::InvalidArgumentsError unless argument_parser.valid?
    options = argument_parser.parse_options
    Cacher.new(CACHE_DIR).invalidate if options.invalidate
    AppCreator.new.create(argument_parser.parse_resources, options)
  end
end
