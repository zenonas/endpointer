require 'spec_helper'

describe Endpointer::Performers::Post do
  let(:url) { "http://example.com/foo" }
  let(:headers) do
    {
      'Authorization' => 'Bearer expected'
    }
  end
  let(:request) { double(:request, env: headers, path: URI.parse(url).path, body: request_body) }
  let(:request_body) do
    s = StringIO.new
    s.write '{\"foo\":\"bar\"}'
    s
  end
  let(:headers) { { 'Authorization' => 'Bearer test' } }
  let(:resource) { Endpointer::Resource.new("resource", :post, url, headers) }
  let(:expected_response_body) { 'some response' }

  let(:expected_response_headers) { { 'CONTENT-TYPE' => 'application/json' } }
  let(:response_presenter) { double(Endpointer::ResponsePresenter) }

  before do
    allow(Endpointer::ResponsePresenter).to receive(:new).and_return(response_presenter)
  end

  describe '#execute' do
    %w{post put patch}.each do |verb|
      context "[#{verb}] when the request is successful" do
        let(:expected_response) { Endpointer::Response.new(201, expected_response_body, expected_response_headers) }
        let(:resource) { Endpointer::Resource.new("resource", verb.to_sym, url, headers) }

        before do
          stub_request(resource.method, resource.url).with(body: request.body.read, headers: headers)
            .to_return(status: 201, body: expected_response_body, headers: expected_response_headers)
          allow(response_presenter).to receive(:present).with(status: 201, body: expected_response_body, headers: {content_type: 'application/json'}).and_return(expected_response)
        end

        it 'executes a get request to the resource with the configured headers' do
          expect(subject.execute(request, resource)).to eq(expected_response)
        end
      end
    end

    context 'when there is a problem' do
      let(:expected_response) { Endpointer::Response.new(500, expected_response_body, expected_response_headers) }

      before do
        stub_request(resource.method, resource.url).with(body: request.body.read, headers: headers)
          .to_return(status: 500, body: expected_response_body, headers: expected_response_headers)
        allow(response_presenter).to receive(:present).with(status: 500, body: expected_response_body, headers: {content_type: 'application/json'}).and_return(expected_response)
      end

      it 'executes a get request to the resource with the configured headers' do
        expect(subject.execute(request, resource)).to eq(expected_response)
      end

    end
  end
end
