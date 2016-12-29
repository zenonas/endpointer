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
  let(:expected_response) do
    Endpointer::Response.new(
      status,
      body,
      {
        'CONTENT-TYPE' => 'application/json',
        'X-SOME-VALUE' => 'value'
      }
    )
  end

  describe '#present' do
    it 'makes the headers sinatra friendly and removes unwanted headers' do
      expect(subject.present(status: status, headers: headers, body: body)).to eq(expected_response)
    end
  end
end
