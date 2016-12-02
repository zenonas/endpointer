require "endpointer/version"
require "endpointer/argument_parser"

module Endpointer

  def self.run(arguments)
    ArgumentParser.new.parse(arguments)


  end
end
