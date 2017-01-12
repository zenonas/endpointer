require 'endpointer/response'
require 'uri'

module Endpointer
  module Performers
    module Method
      def create_headers(request, resource)
        resource.headers.keys.each_with_object({}) do |key, header|
          header[key] = request_header_or_default(key, request, resource)
        end
      end

      def request_header_or_default(key, request, resource)
        request.env[rack_header_name_convert(key)] || resource.headers[key]
      end

      def rack_header_name_convert(header_name)
        "HTTP_#{header_name.upcase.tr('-', '_')}"
      end

      def construct_uri(request, resource)
        parsed_request_url = URI.parse(request.url)
        parsed_resource_url = URI.parse(resource.url)

        parsed_request_url.scheme = parsed_resource_url.scheme
        parsed_request_url.userinfo = parsed_resource_url.userinfo
        parsed_request_url.host = parsed_resource_url.host
        parsed_request_url.port = parsed_resource_url.port

        parsed_request_url.to_s
      end
    end
  end
end
