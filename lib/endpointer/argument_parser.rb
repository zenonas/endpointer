require 'endpointer/resource'
require 'endpointer/options'

module Endpointer
  class ArgumentParser

    def initialize(arguments)
      @arguments = arguments
    end

    def parse_resources
      parse_config(config_file).map do |resource|
        Resource.new(resource["url"], resource["headers"])
      end
    end

    def parse_options
      options = @arguments.select { |argument| option_argument?(argument)}
      build_options_from(options)
    end

    private

    def build_options_from(parsed_options)
      invalidate = parsed_options.include?("--invalidate")
      Options.new(invalidate)
    end

    def config_file
      @arguments.find { |argument| config_file?(argument) }
    end

    def parse_config(config_file)
      JSON.parse(File.read(config_file))
    end

    def resources_from_config_file
    end

    def option_argument?(argument)
      argument.match(/^--.*/)
    end

    def config_file?(argument)
      argument.match(/.json$/) || File.exists?(argument)
    end

  end
end
