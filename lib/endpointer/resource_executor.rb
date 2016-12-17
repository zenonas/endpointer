require 'endpointer/cacher'
require 'endpointer/performer_factory'

module Endpointer
  class ResourceExecutor

    def perform(request, resource, options)
      begin
        cache.get(resource)
      rescue Endpointer::Errors::CachedItemNotFoundError => e
        response = Endpointer::PerformerFactory.create(resource.method).execute(request, resource)
        cache.set(resource, response)
        response
      end
    end

    private

    def cache
      @cache ||= Endpointer::Cacher.new(Endpointer::CACHE_DIR)
    end

  end
end
