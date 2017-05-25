require 'endpointer/errors/cached_item_not_found_error'
require 'endpointer/errors/invalid_cache_dir_error'
require 'endpointer/cache_container'
require 'endpointer/cache_key_resolver'
require 'endpointer/response_presenter'
require 'yaml'

module Endpointer
  class Cacher

    def initialize(path)
      initialize_path(path)
    end

    def get(resource, request_body)
      cache_key = get_cache_key(resource, request_body)
      cache_container = retrieve_cache_container(cache_key)
      raise Endpointer::Errors::CachedItemNotFoundError unless cache_container.resource == resource
      present_response(resource, request_body, cache_container)
    end

    def set(resource, request_body, response)
      cache_container = create_cache_container(resource, response)
      File.write(File.join(@path, get_cache_key(resource, request_body)), YAML.dump(cache_container))
    end

    def invalidate
      FileUtils.remove_entry(@path)
      initialize_path(@path)
    end

    private

    def create_cache_container(resource, response)
      Endpointer::CacheContainer.new(resource, response, Time.now.utc)
    end

    def retrieve_cache_container(cache_key)
      begin
        YAML.load(File.read(File.join(@path, cache_key)))
      rescue Errno::ENOENT => e
        raise Endpointer::Errors::CachedItemNotFoundError, e.message
      end
    end

    def get_cache_key(resource, request_body)
      Endpointer::CacheKeyResolver.new.get_key(resource, request_body)
    end

    def initialize_path(path)
      begin
        @path = path
        Dir.mkdir(@path) unless File.exist?(@path)
      rescue Errno::ENOENT => e
        raise Endpointer::Errors::InvalidCacheDirError, e.message
      end
    end

    def present_response(resource, request_body, cache_container)
      Endpointer::ResponsePresenter.new.present(
        status: cache_container.response.code,
        body: cache_container.response.body,
        headers: cache_container.response.headers,
        request_body: request_body,
        resource: resource
      )
    end
  end
end
