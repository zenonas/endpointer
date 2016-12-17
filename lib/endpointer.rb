require "endpointer/version"
require "endpointer/argument_parser"
require "endpointer/app_creator"

module Endpointer

  CACHE_DIR = File.join(Dir.tmpdir, "endpointer_cache")

  def self.run(arguments)
    argument_parser = ArgumentParser.new(arguments)
    options = argument_parser.parse_options
    Cacher.new(CACHE_DIR).invalidate if options.invalidate
    app = AppCreator.new.create(argument_parser.parse_resources, options)
    app.run!
  end
end
