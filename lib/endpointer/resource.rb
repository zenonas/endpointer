module Endpointer
  class Resource < Struct.new(:id, :method, :url, :headers, :matchers)
  end
end
