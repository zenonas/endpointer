require 'spec_helper'

describe Endpointer::ResourceExecutor do
  let(:url) { "http://example.com/foo" }
  let(:headers) { { 'Authorization' => 'Bearer test' } }
  let(:options) { Endpointer::Options.new(true) }
  let(:resource) { Endpointer::Resource.new(:get, url, headers) }

  let(:request) { double(:request) }

  let(:cacher) { double(:cacher) }
  let(:response) { double(:response) }
  let(:performer) { double(:performer) }

  before do
    allow(Endpointer::Cacher).to receive(:new).and_return(cacher)
    allow(Endpointer::PerformerFactory).to receive(:create).with(:get).and_return(performer)
  end

  describe '#perform' do
    context 'the cache has the resource' do
      before do
        allow(cacher).to receive(:get).with(resource).and_return(response)
      end

      it 'returns the response from the cache' do
        expect(subject.perform(request, resource, options)).to eq response
      end
    end

    context 'the cache doesnt have the resource' do
      before do
        allow(cacher).to receive(:get).with(resource).and_raise(Endpointer::Errors::CachedItemNotFoundError)
        allow(performer).to receive(:execute).with(request, resource).and_return(response)
      end

      it 'uses the performer factory' do
        expect(subject.perform(request, resource, options)).to eq response
      end
    end
  end
end
