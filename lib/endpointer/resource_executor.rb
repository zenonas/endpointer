require 'endpointer/cacher'
require 'endpointer/performer_factory'

module Endpointer
  class ResourceExecutor

    def perform(request, resource, options)
      begin
        cache(options.cache_dir).get(resource, get_request_body(request))
      rescue Endpointer::Errors::CachedItemNotFoundError
        response = Endpointer::PerformerFactory.create(resource.method).execute(request, resource)
        cache(options.cache_dir).set(resource, response)
        response
      end
    end

    private

    def cache(cache_dir)
      @cache ||= Endpointer::Cacher.new(cache_dir)
    end

    def get_request_body(request)
      request_body = request.body.read
      request.body.rewind
      request_body
    end
  end
end
