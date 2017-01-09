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
          url = File.join(create_hostname(resource), create_path(request))
          response = RestClient.send(method,
            url,
            request.body.string,
            create_headers(request, resource)
          )
        rescue RestClient::ExceptionWithResponse => e
          response = e.response
        end

        Endpointer::ResponsePresenter.new.present(status: response.code, body: response.body, headers: response.headers)
      end
    end
  end
end
