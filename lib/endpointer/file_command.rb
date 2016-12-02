require 'endpointer/command'
require 'json'

module Endpointer
  class FileCommand < Command

    def initialize(argument)
      @file = JSON.parse(File.read(argument))
    end

    def file?
      true
    end

  end
end
