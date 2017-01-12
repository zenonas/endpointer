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
        begin
          response = RestClient.send(method,
            construct_uri(request, resource),
            request.body.read,
            create_headers(request, resource)
          )
          request.body.rewind
        rescue RestClient::ExceptionWithResponse => e
          response = e.response
        end

        Endpointer::ResponsePresenter.new.present(status: response.code, body: response.body, headers: response.headers)
      end
    end
  end
end
