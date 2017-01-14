require 'json'
require 'endpointer/resource'

module Endpointer
  class ResourceParser
    def parse(resource_config)
      parse_config(resource_config).map do |resource|
        Resource.new(resource["id"], resource["method"].to_sym, resource["url"], resource["headers"])
      end
    end

    private

    def parse_config(config)
      begin
        JSON.parse(config)
      rescue JSON::ParserError
        abort("Error: The resource config is invalid")
      end
    end
  end
end
