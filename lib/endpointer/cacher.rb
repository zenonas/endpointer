require 'endpointer/errors/cached_item_not_found_error'

module Endpointer
  class Cacher
    def get(resource)
      raise Endpointer::Errors::CachedItemNotFoundError.new
    end
  end
end

