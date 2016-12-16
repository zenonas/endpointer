require 'spec_helper'
require 'uri'

describe Endpointer::Performers::Get do
  let(:url) { "http://example.com/foo" }
  let(:headers) do
    {
      'Authorization' => 'Bearer expected'
    }
  end
  let(:request) { double(:request, env: headers, path: URI.parse(url).path) }
  let(:headers) { { 'Authorization' => 'Bearer test' } }
  let(:resource) { Endpointer::Resource.new(:get, url, headers) }


  let(:expected_response_body) { 'some response' }
  let(:expected_response_headers) { { 'CONTENT-TYPE' => 'application/json' } }
  let(:response_presenter) { double(Endpointer::ResponsePresenter) }


  before do
    allow(Endpointer::ResponsePresenter).to receive(:new).and_return(response_presenter)
  end

  describe '#execute' do
    context 'when there request is successful' do
      let(:expected_response) { Endpointer::Response.new(200, expected_response_body, expected_response_headers) }

      before do
        stub_request(resource.method, resource.url).with(headers: headers)
          .to_return(body: expected_response_body, headers: expected_response_headers)
        allow(response_presenter).to receive(:present).with(status: 200, body: expected_response_body, headers: {content_type: 'application/json'}).and_return(expected_response)
      end

      it 'executes a get request to the resource with the configured headers' do
        expect(subject.execute(request, resource)).to eq(expected_response)
      end
    end

    context 'when there is a problem' do
      let(:expected_response) { Endpointer::Response.new(500, expected_response_body, expected_response_headers) }

      before do
        stub_request(resource.method, resource.url).with(headers: headers)
          .to_return(status: 500, body: expected_response_body, headers: expected_response_headers)
        allow(response_presenter).to receive(:present).with(status: 500, body: expected_response_body, headers: {content_type: 'application/json'}).and_return(expected_response)
      end

      it 'executes a get request to the resource with the configured headers' do
        expect(subject.execute(request, resource)).to eq(expected_response)
      end

    end
  end
end
