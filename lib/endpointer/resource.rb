module Endpointer
  class Resource < Struct.new(:method, :url, :headers)
  end
end
