require 'endpointer/performers/method'
require 'endpointer/response_presenter'
require 'rest-client'

module Endpointer
  module Performers
    class Get
      include Endpointer::Performers::Method

      def execute(request, resource)
        begin
          url = File.join(create_hostname(resource), create_path(request))
          response = RestClient::Request.execute(method: :get, url: url, headers: create_headers(request, resource))
        rescue RestClient::ExceptionWithResponse => e
          response = e.response
        end
        Endpointer::ResponsePresenter.new.present(status: response.code, body: response.body, headers: response.headers)
      end
    end
  end
end
