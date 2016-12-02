require 'endpointer/command'
require 'endpointer/errors/invalid_argument_error'

module Endpointer
  class ActionCommand < Command

    ARGUMENT_MAP = {
      '--invalidate' => :invalidate_caches,
      '--debug' => :debug,
    }

    def initialize(argument)
      @action = ARGUMENT_MAP.fetch(argument) { raise InvalidArgumentError.new("Please don't enter invalid arguments") }
    end

    def action?
      true
    end

    def resource_action?
      true
    end

  end
end
