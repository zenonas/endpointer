module Endpointer
  class Configuration

    attr_accessor :invalidate, :cache_dir, :resource_config

    DEFAULT_CONFIG_PATH = './endpointer.json'

    def initialize(invalidate = nil, cache_dir = nil)
      @invalidate = invalidate || false
      @cache_dir = cache_dir || File.join(Dir.tmpdir, "endpointer_cache")
      begin
        @resource_config = File.read(DEFAULT_CONFIG_PATH)
      rescue Errno::ENOENT
        @resource_config = nil
      end
    end
  end
end
