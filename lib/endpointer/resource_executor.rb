require 'endpointer/cacher'
require 'endpointer/performer_factory'

module Endpointer
  class ResourceExecutor

    def perform(request, resource, options)
      begin
        Endpointer::Cacher.new.get(resource)
      rescue Endpointer::Errors::CachedItemNotFoundError => e
        Endpointer::PerformerFactory.create(resource.method).execute(request, resource)
      end
    end

  end
end
