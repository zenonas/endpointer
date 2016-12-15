require "endpointer/version"
require "endpointer/argument_parser"
require "endpointer/app_creator"

module Endpointer

  def self.run(arguments)
    argument_parser = ArgumentParser.new(arguments)
    app = AppCreator.new.create(argument_parser.parse_resources, argument_parser.parse_options)
    app.run!
  end
end
