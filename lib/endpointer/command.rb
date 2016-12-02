module Endpointer
  class Command

    attr_reader :file, :action
    def initialize(argument)
    end

    def file?
      false
    end

    def action?
      false
    end

    def resource_action?
      false
    end

  end
end
