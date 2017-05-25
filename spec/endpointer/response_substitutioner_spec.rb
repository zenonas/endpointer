require 'spec_helper'

describe Endpointer::ResponseSubstitutioner do
  describe '#substitute' do
    let(:value1) { 'example-value' }
    let(:value2) { 'example-value2' }

    let(:request_body) { "<example><value1>#{value1}</value1><value2>#{value2}</value2></example>" }
    let(:response_body) { '{"example":{"value1":"foo","value2":"bar"}}' }
    let(:substitutions) do
      [
        {
          'from_request' => '<value1>(?<match>.*)</value1>',
          'to_response' => '"value1":"(?<match>\w+)"'
        },
        {
          'from_request' => '<value2>(?<match>.*)</value2>',
          'to_response' => '"value2":"(?<match>\w+)"'
        }
      ]
    end

    context 'when there are substitutions' do
      it 'substitutes the captured values in the request regex to the captured position of the response' do
        result = JSON.parse(subject.substitute(request_body, response_body, substitutions))
        expect(result['example']['value1']).to eq value1
        expect(result['example']['value2']).to eq value2
      end
    end

    context 'when there are no substitutions' do
      it 'returns the body unmodified if the substitutions are nil' do
        expect(subject.substitute(request_body, response_body, nil)).to eq(response_body)
      end

      it 'returns the body unmodified if the substitutions are empty' do
        expect(subject.substitute(request_body, response_body, [])).to eq(response_body)
      end
    end
  end
end
