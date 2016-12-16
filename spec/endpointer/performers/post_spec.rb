require 'spec_helper'

describe Endpointer::Performers::Post do
  let(:url) { "http://example.com/foo" }
  let(:headers) do
    {
      'Authorization' => 'Bearer expected'
    }
  end
  let(:request) { double(:request, env: headers, path: url, body: request_body) }
  let(:request_body) { double(:body, string: "{\"foo\":\"bar\"}") }
  let(:headers) { { 'Authorization' => 'Bearer test' } }
  let(:resource) { Endpointer::Resource.new(:post, url, headers) }
  let(:expected_response_body) { 'some response' }
  let(:expected_response_headers) { { :content_type => 'application/json' } }


  describe '#execute' do
    context 'when there request is successful' do
      let(:expected_response) { Endpointer::Response.new(201, expected_response_body, expected_response_headers) }

      before do
        stub_request(resource.method, resource.url).with(body: request.body.string, headers: headers)
          .to_return(status: 201, body: expected_response_body, headers: expected_response_headers)
      end

      it 'executes a get request to the resource with the configured headers' do
        expect(subject.execute(request, resource)).to eq(expected_response)
      end
    end

    context 'when there is a problem' do
      let(:expected_response) { Endpointer::Response.new(500, expected_response_body, expected_response_headers) }

      before do
        stub_request(resource.method, resource.url).with(body: request.body.string, headers: headers)
          .to_return(status: 500, body: expected_response_body, headers: expected_response_headers)
      end

      it 'executes a get request to the resource with the configured headers' do
        expect(subject.execute(request, resource)).to eq(expected_response)
      end

    end
  end
end
