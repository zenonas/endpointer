module Endpointer
  class ResponsePresenter

    def present(status: , body: , headers: )
      Response.new(
        status,
        body,
        sanitise_headers(uglify_headers(headers))
      )
    end

    private

    def uglify_headers(headers)
      headers.inject({}) { |out, (key, value)|
        out[key.to_s.upcase.gsub('_', '-')] = value
        out
      }
    end

    def sanitise_headers(headers)
      headers.reject {|header, value|
        header.match(/TRANSFER-ENCODING/)
      }
    end

  end
end
