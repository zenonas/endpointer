require 'endpointer/cacher'
require 'endpointer/performer_factory'

module Endpointer
  class ResourceExecutor

    def perform(request, resource, options)
      begin
        cache(options.cache_dir).get(resource)
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
  end
end
