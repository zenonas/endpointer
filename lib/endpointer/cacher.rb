require 'endpointer/errors/cached_item_not_found_error'
require 'endpointer/cache_container'

module Endpointer
  class Cacher

    def initialize(path)
      @path = path
    end

    def get(resource)
      cache_container = retrieve_cache_container(resource)
      raise Endpointer::Errors::CachedItemNotFoundError unless cache_container.resource == resource
      cache_container.response
    end

    private

    def retrieve_cache_container(resource)
      begin
        YAML.load(File.read(File.join(@path, "#{resource.id}.yml")))
      rescue
        raise Endpointer::Errors::CachedItemNotFoundError
      end
    end
  end
end

