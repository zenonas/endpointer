module Endpointer
  class ResponseSubstitutioner

    def substitute(request_body, response_body, substitutions)
      return response_body if substitutions.nil?
      
      substitutions.inject(response_body) do |output, substitution|
        value_to_use = get_value_to_use(request_body, substitution)
        value_to_replace = get_value_to_replace(response_body, substitution)
        output.gsub(value_to_replace, value_to_use)
      end
    end

    private

    def get_value_to_use(request_body, substitution)
      request_body.match(Regexp.new(substitution.fetch('from_request')))[:match]
    end

    def get_value_to_replace(response_body, substitution)
      response_body.match(Regexp.new(substitution.fetch('to_response')))[:match]
    end
  end
end
