require 'endpointer/performers/method'
require 'endpointer/response_presenter'
require 'rest-client'

module Endpointer
  module Performers
    class Post
      include Endpointer::Performers::Method

      def execute(request, resource)
        execute_method(resource.method, request, resource)
      end

      private

      def execute_method(method, request, resource)
        request_body = request.body.read

        begin
          response = RestClient.send(method,
            construct_uri(request, resource),
            request_body,
            create_headers(request, resource)
          )
          request.body.rewind
        rescue RestClient::ExceptionWithResponse => e
          response = e.response
        end

        Endpointer::ResponsePresenter.new.present(status: response.code, body: response.body, headers: response.headers, request_body: request_body, resource: resource)
      end
    end
  end
end
