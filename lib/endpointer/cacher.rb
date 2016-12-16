require 'endpointer/errors/cached_item_not_found_error'
require 'endpointer/cache_container'
require 'yaml'

module Endpointer
  class Cacher

    def initialize(path)
      initialize_path(path)
    end

    def get(resource)
      cache_container = retrieve_cache_container(resource)
      raise Endpointer::Errors::CachedItemNotFoundError unless cache_container.resource == resource
      cache_container.response
    end

    def set(resource, response)
      cache_container = create_cache_container(resource, response)
      File.write(File.join(@path, "#{resource.id}.yml"), YAML.dump(cache_container))
    end

    def invalidate
      FileUtils.remove_entry(@path)
      initialize_path(@path)
    end

    private

    def create_cache_container(resource, response)
      Endpointer::CacheContainer.new(resource, response, Time.now.utc)
    end

    def retrieve_cache_container(resource)
      begin
        YAML.load(File.read(File.join(@path, "#{resource.id}.yml")))
      rescue
        raise Endpointer::Errors::CachedItemNotFoundError
      end
    end

    def initialize_path(path)
      @path = path
      Dir.mkdir(@path) unless File.exists?(@path)
    end
  end
end
