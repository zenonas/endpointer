module Endpointer
  class Options

    attr_accessor :invalidate, :cache_dir

    def initialize(invalidate = nil, cache_dir = nil)
      @invalidate = invalidate || false
      @cache_dir = cache_dir || File.join(Dir.tmpdir, "endpointer_cache")
    end
  end
end
