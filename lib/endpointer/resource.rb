module Endpointer
  class Resource < Struct.new(:id, :method, :url, :headers)
  end
end
