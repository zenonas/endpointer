require 'spec_helper'
require 'json'

describe Endpointer::ResponsePresenter do
  let(:headers) do
    {
      content_type: 'application/json',
      x_some_value: 'value',
      transfer_encoding: 'chunked'
    }

  end
  let(:body) { JSON.generate({foo: 'bar'}) }
  let(:status) { 200 }
  let(:substitutions) { [:sub_a, :sub_b] }
  let(:resource) { double(Endpointer::Resource, substitutions: substitutions) }
  let(:request_body) { 'request_body' }
  let(:expected_response) do
    Endpointer::Response.new(
      status,
      substituted_body,
      {
        'CONTENT-TYPE' => 'application/json',
        'X-SOME-VALUE' => 'value'
      }
    )
  end
  let(:substituted_body) { 'a substituted_body' }
  let(:response_substitutioner) { double(Endpointer::ResponseSubstitutioner) }

  before do
    allow(Endpointer::ResponseSubstitutioner).to receive(:new).and_return(response_substitutioner)
    allow(response_substitutioner).to receive(:substitute).with(request_body, body, substitutions).and_return(substituted_body)
  end

  describe '#present' do
    it 'makes the headers sinatra friendly and removes unwanted headers' do
      expect(subject.present(status: status, headers: headers, body: body, request_body: request_body, resource: resource)).to eq(expected_response)
    end
  end
end
