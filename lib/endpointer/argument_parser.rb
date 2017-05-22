require 'endpointer/resource'
require 'endpointer/configuration'
require 'optionparser'
require 'json'

module Endpointer
  class ArgumentParser

    def parse(arguments)
      begin
        opt_parser.parse(arguments)
      rescue OptionParser::InvalidOption => e
        abort "Error: #{e}"
      end

      configuration
    end

    private

    def opt_parser
      OptionParser.new do |parser|
        parser.banner = "Usage: endpointer [options]"

        parser.on("-d CACHE_DIR", "--cache-dir CACHE_DIR", "Modifies the default cache directory [Default: TMP_DIR/endpointer_cache]") do |cache_dir|
          configuration.cache_dir = cache_dir if cache_dir
        end

        parser.on("-i", "--invalidate", "Invalidates the cache at startup") do
          configuration.invalidate = true
        end

        parser.on("-c CONFIG", "--config CONFIG", "Override the default resource config file path. [Default: ./endpointer.json]") do |config|
          begin
            resource_config = File.read(config)
            configuration.resource_config = resource_config
          rescue Errno::ENOENT
            abort "Error: Config file supplied does not exist"
          end
        end
      end
    end

    def configuration
      @configuration ||= Endpointer::Configuration.new
    end
  end
end
