require 'endpointer/response'
require 'uri'

module Endpointer
  module Performers
    class Method

      def execute(request, resource)
      end

      private

      def create_headers(request, resource)
        resource.headers.keys.each_with_object({}) do |key, header|
          header[key] = request.env[key] || resource.headers[key]
        end
      end

      def create_hostname(resource)
        host = URI.parse(resource.url).host
        port = URI.parse(resource.url).port
        "#{host}:#{port}"
      end

      def create_path(request)
        path = request.path
        query_string = request.env['QUERY_STRING']
        path << "?#{query_string}" unless query_string.nil?
        path
      end
    end
  end
end
