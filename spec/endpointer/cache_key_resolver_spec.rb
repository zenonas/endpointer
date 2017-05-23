require 'spec_helper'
require 'tempfile'

describe Endpointer::CacheKeyResolver do

  let(:resource) { Endpointer::Resource.new('some-id', 'get', 'some-url', {'HEADER' => 'value'}, matchers) }
  let(:request_body) { 'This is a request body that has something in it' }

  describe'#get_key'do
    context 'when there are no matchers' do
      let(:matchers) { nil }

      it 'returns a keyname with the id as the filename' do
        expect(subject.get_key(resource, request_body)).to eq('some-id.yml')
      end
    end

    context 'when there are matchers' do
      let(:matchers) do
        { 'matcher1' => 'something', 'matcher2' => 'anotherthing' }
      end

      it 'returns the correct key name for the cache' do
        expect(subject.get_key(resource, request_body)).to eq('some-id_matcher1.yml')
      end

      context 'when no matcher matches anything' do
        let(:matchers) do
          { 'matcher1' => 'unmatched' }
        end

        it 'returns the key without a matcher name in the id' do
          expect(subject.get_key(resource, request_body)).to eq('some-id.yml')
        end
      end
    end
  end
end
