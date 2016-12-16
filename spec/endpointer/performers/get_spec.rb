require 'spec_helper'

describe Endpointer::Performers::Get do
  let(:url) { "http://example.com/foo" }
  let(:headers) do
    {
      'Authorization' => 'Bearer expected'
    }
  end
  let(:request) { double(:request, env: headers, path: url) }
  let(:headers) { { 'Authorization' => 'Bearer test' } }
  let(:resource) { Endpointer::Resource.new(:get, url, headers) }

  let(:expected_response) { Endpointer::Response.new(200, expected_response_body, expected_response_headers) }

  let(:expected_response_body) { 'some response' }
  let(:expected_response_headers) { { :content_type => 'application/json' } }

  before do
    stub_request(resource.method, resource.url).with(headers: headers)
      .to_return(body: expected_response_body, headers: expected_response_headers)
  end

  describe '#execute' do
    it 'executes a get request to the resource with the configured headers' do
      expect(subject.execute(request, resource)).to eq(expected_response)
    end
  end
end
