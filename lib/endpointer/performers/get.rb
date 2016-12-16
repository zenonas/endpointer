require 'endpointer/response'
require 'rest-client'

module Endpointer
  module Performers
    class Get

      def execute(request, resource)
        response = RestClient::Request.execute(method: :get, url: request.path, headers: create_headers(request, resource))
        Endpointer::Response.new(response.code, response.body, response.headers)
      end

      private

      def create_headers(request, resource)
        resource.headers.keys.each_with_object({}) do |key, header|
          header[key] = request.env[key] || resource.headers[key]
        end
      end
    end
  end
end
