require 'spec_helper'

describe Endpointer::AppCreator do
  let(:url1) { "http://example.com/foo" }
  let(:url2) { "http://example.com/bar" }
  let(:invalidate) { true }
  let(:resource1) { Resource.new(url1, ["Authorization: Bearer bar"]) }
  let(:resource2) { Resource.new(url2, []) }
  let(:resources) { [resource1, resource2] }
  let(:options) { Options.new(invalidate) }
  describe '#create' do


  end
end
