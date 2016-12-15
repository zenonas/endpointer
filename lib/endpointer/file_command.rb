require 'json'

module Endpointer
  class FileCommand

    attr_reader :file

    def initialize(argument)
      @file = JSON.parse(File.read(argument))
    end

  end
end
