require 'endpointer/app'
require 'endpointer/resource_executor'
require 'uri'

module Endpointer
  class AppCreator

    def create(resources, options)
      resources.each do |resource|
        app.send(resource.method, path(resource.url)) do
          executor_response = Endpointer::ResourceExecutor.new.perform(request, resource, options)
          headers executor_response.headers
          executor_response.body
        end
      end
      app
    end

    private

    def app
      @app ||= Sinatra.new(Endpointer::App)
    end

    def path(url)
      URI.parse(url).path
    end
  end
end
