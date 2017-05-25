require 'endpointer/response_substitutioner'
module Endpointer
  class ResponsePresenter

    def present(status: , body: , headers: , request_body: , resource: )
      Response.new(
        status,
        substituted_body(request_body, body, resource),
        sanitise_headers(uglify_headers(headers))
      )
    end

    private

    def uglify_headers(headers)
      headers.inject({}) { |out, (key, value)|
        out[key.to_s.upcase.tr('_', '-')] = value
        out
      }
    end

    def sanitise_headers(headers)
      headers.reject {|header, _|
        header.match(/TRANSFER-ENCODING/)
      }
    end

    def substituted_body(request_body, response_body, resource)
      Endpointer::ResponseSubstitutioner.new.substitute(request_body, response_body, resource.substitutions)
    end

  end
end
