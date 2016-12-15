require 'endpointer/action_commands/invalidate_cache'
require 'endpointer/errors/invalid_argument_error'

module Endpointer
  class ActionCommandFactory

    ARGUMENT_MAP = {
      '--invalidate' => Endpointer::ActionCommands::InvalidateCache
    }

    def self.create(argument)
      ARGUMENT_MAP.fetch(argument) {
        raise InvalidArgumentError.new("Please don't enter invalid arguments")
      }.new
    end
  end
end
