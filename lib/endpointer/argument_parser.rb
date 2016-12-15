require 'endpointer/action_command_factory'
require 'endpointer/file_command'

module Endpointer
  class ArgumentParser

    def parse(arguments)
      arguments.flat_map do |argument|
        parse_argument(argument)
      end
    end

    private

    def parse_argument(argument)
      return FileCommand.new(argument) if file_command?(argument)
      return ActionCommandFactory.create(argument) if action_command?(argument)
    end

    def action_command?(argument)
      argument.match(/^--.*/)
    end

    def file_command?(argument)
      argument.match(/.json$/) || File.exists?(argument)
    end

  end
end
