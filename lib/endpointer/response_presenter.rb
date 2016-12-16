module Endpointer
  class ResponsePresenter

    def present(status: , body: , headers: )
      Response.new(
        status,
        body,
        uglify_headers(headers)
      )
    end

    private

    def uglify_headers(headers)
      headers.inject({}) { |out, (key, value)|
        out[key.to_s.upcase.gsub('_', '-')] = value
        out
      }
    end

  end
end
