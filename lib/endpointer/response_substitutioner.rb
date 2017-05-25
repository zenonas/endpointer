module Endpointer
  class ResponseSubstitutioner

    def substitute(request_body, response_body, substitutions)
      return response_body if substitutions.nil?

      substitutions.inject(response_body) do |output, substitution|
        value_to_use = get_value_for(request_body, substitution.fetch('from_request'))
        value_to_replace = get_value_for(response_body, substitution.fetch('to_response'))
        output.gsub(value_to_replace, value_to_use)
      end
    end

    private

    def get_value_for(string, regex)
      match_data = string.match(Regexp.new(regex))

      if match_data
        match_data[:match]
      else
        ''
      end
    end
  end
end
