require 'spec_helper'

describe Endpointer::Performers::Method do

  let(:resource) { Endpointer::Resource.new("some_id", "post", url, {}) }
  let(:request) { double(:request, url: 'http://user:pass@localhost:4567/baz/crux?quz=corge') }

  subject { Class.new { include Endpointer::Performers::Method }.new }

  describe '.construct_uri' do
    context 'when the url is using http' do
      let(:url) { 'http://example.com/foo/bar/baz' }

      let(:expected_uri) { 'http://user:pass@example.com/baz/crux?quz=corge' }

      it 'returns the url' do
        expect(subject.construct_uri(request, resource)).to eq expected_uri
      end
    end

    context 'when the url has a port' do
      let(:url) { 'https://foo:bar@example.com:9876/baz/crux?quz=corge' }

      let(:expected_uri) { 'https://foo:bar@example.com:9876/baz/crux?quz=corge' }

      it 'can deal with it' do
        expect(subject.construct_uri(request, resource)).to eq expected_uri
      end
    end
  end
end
