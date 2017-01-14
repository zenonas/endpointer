require 'spec_helper'
require 'tempfile'

describe Endpointer::ResourceParser do

  let(:id1) { 'foo' }
  let(:id2) { 'bar' }
  let(:url1) { "http://example.com/foo" }
  let(:url2) { "http://example.com/bar" }
  let(:header1) { { "Authorization" => "Bearer foo" } }
  let(:header2) { { "Authorization" => "Bearer bar" } }
  let(:cache_path) { '/some/path' }

  describe'#parse'do
    let(:resource_config) do
      JSON.generate(
      [
        {
          id: id1,
          method: :get,
          url: url1,
          headers: header1
        },
        {
          id: id2,
          method: :post,
          url: url2,
          headers: header2
        }
      ]
      )
    end

    it 'provides a list of resources' do
      result = subject.parse(resource_config)
      expect(result.count).to eq(2)
      expect(result.first.id).to eq(id1)
      expect(result.first.method).to eq(:get)
      expect(result.first.url).to eq(url1)
      expect(result.first.headers).to eq(header1)
      expect(result.last.id).to eq(id2)
      expect(result.last.method).to eq(:post)
      expect(result.last.url).to eq(url2)
      expect(result.last.headers).to eq(header2)
    end

    context 'when the resource config is invalid' do
      let(:resource_config) { 'something' }

      it 'aborts the application' do
        begin
          expect {
            subject.parse(resource_config)
          }.to output("Error: The resource config is invalid").to_stderr
        rescue SystemExit
        end
      end
    end
  end
end
