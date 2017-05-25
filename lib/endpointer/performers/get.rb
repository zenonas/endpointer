require 'endpointer/performers/method'
require 'endpointer/response_presenter'
require 'rest-client'

module Endpointer
  module Performers
    class Get
      include Endpointer::Performers::Method

      def execute(request, resource)
        execute_method(resource.method, request, resource)
      end

      private

      def execute_method(method, request, resource)
        begin
          response = RestClient::Request.execute(method: method, url: construct_uri(request, resource), headers: create_headers(request, resource))
        rescue RestClient::ExceptionWithResponse => e
          response = e.response
        end

        request_body = request.body.read
        request.body.rewind
        Endpointer::ResponsePresenter.new.present(status: response.code, body: response.body, headers: response.headers, request_body: request_body, resource: resource)
      end
    end
  end
end
