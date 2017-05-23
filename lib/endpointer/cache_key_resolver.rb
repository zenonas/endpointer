module Endpointer
  class CacheKeyResolver
    def get_key(resource, request_body)
      return "#{resource.id}.yml" if resource.matchers.nil?

      matches = resource.matchers.select do |_matcher_name, regex|
        request_body.match(regex)
      end

      return "#{resource.id}.yml" if matches.empty?
      "#{resource.id}_#{matches.keys.first}.yml"
    end
  end
end
