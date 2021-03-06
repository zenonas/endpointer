require 'spec_helper'
require 'stringio'

describe Endpointer::ResourceExecutor do
  let(:url) { "http://example.com/foo" }
  let(:headers) { { 'Authorization' => 'Bearer test' } }
  let(:options) { Endpointer::Configuration.new(true) }
  let(:resource) { Endpointer::Resource.new("resource", :get, url, headers) }

  let(:request_body) { "some body text" }
  let(:body_string_io) do
    io = StringIO.new
    io << request_body
    io.rewind
    io
  end

  let(:request) { double(:request, body: body_string_io) }

  let(:cacher) { double(:cacher) }
  let(:response) { double(:response) }
  let(:performer) { double(:performer) }

  before do
    allow(Endpointer::Cacher).to receive(:new).with(options.cache_dir).and_return(cacher)
    allow(Endpointer::PerformerFactory).to receive(:create).with(:get).and_return(performer)
  end

  describe '#perform' do
    context 'the cache has the resource' do
      before do
        allow(cacher).to receive(:get).with(resource, request_body).and_return(response)
      end

      it 'returns the response from the cache' do
        expect(subject.perform(request, resource, options)).to eq response
      end
    end

    context 'the cache doesnt have the resource' do
      before do
        allow(cacher).to receive(:get).with(resource, request_body).and_raise(Endpointer::Errors::CachedItemNotFoundError)
        allow(cacher).to receive(:set).with(resource, request_body, response)
        allow(performer).to receive(:execute).with(request, resource).and_return(response)
      end

      it 'uses the performer factory' do
        expect(subject.perform(request, resource, options)).to eq response
      end

      it 'stores the response in the cache' do
        expect(cacher).to receive(:set).with(resource, request_body, response)
        subject.perform(request, resource, options)
      end
    end
  end
end
