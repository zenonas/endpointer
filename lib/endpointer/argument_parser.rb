require 'endpointer/resource'
require 'endpointer/options'
require 'json'

module Endpointer
  class ArgumentParser

    VALID_OPTIONS = [
      '--invalidate',
      '--cache-dir='
    ]

    def initialize(arguments)
      @arguments = arguments
    end

    def parse_resources
      parse_config(config_file).map do |resource|
        Resource.new(resource["id"], resource["method"].to_sym, resource["url"], resource["headers"])
      end
    end

    def parse_options
      options = @arguments.select { |argument| option_argument?(argument)}
      build_options_from(options)
    end

    def valid?
      return false unless config_file
      valid_arguments = VALID_OPTIONS + [config_file]
      return false if @arguments.any? { |arg|
        valid_arguments.none? { |valid_opt| arg.include?(valid_opt) }
      }
      true
    end

    private

    def build_options_from(parsed_options)
      invalidate = parsed_options.include?("--invalidate")
      cache_dir_arg = parsed_options.find { |opt| opt.match(/^--cache-dir/) }
      cache_dir = cache_dir_arg.split('=').last unless cache_dir_arg.nil?

      Options.new(invalidate, cache_dir)
    end

    def config_file
      @arguments.find { |argument| config_file?(argument) }
    end

    def parse_config(config_file)
      JSON.parse(File.read(config_file))
    end

    def option_argument?(argument)
      argument.match(/^--.*/)
    end

    def config_file?(argument)
      argument.match(/.json$/) || File.exist?(argument)
    end

  end
end
