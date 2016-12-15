require "endpointer/version"
require "endpointer/argument_parser"

module Endpointer

  def self.run(arguments)
    commands = ArgumentParser.new.parse(arguments)
    commands.select { |cmd| cmd.kind_of?(Endpointer::ActionCommand) }.map(&:run)
  end
end
