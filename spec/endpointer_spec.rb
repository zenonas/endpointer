require 'spec_helper'

describe Endpointer do
  it 'has a version number' do
    expect(Endpointer::VERSION).not_to be nil
  end

  let(:config) { Endpointer::Configuration.new }
  let(:app_creator) { double(:app_creator) }
  let(:app) { double(:app) }
  let(:cacher) { double(:cacher) }

  before do
    allow(Endpointer::AppCreator).to receive(:new).and_return(app_creator)
    allow(app_creator).to receive(:create).and_return(app)
    allow(Endpointer::Cacher).to receive(:new).with(config.cache_dir).and_return(cacher)
    allow(app).to receive(:run!)
  end

  describe '.run' do
    it 'creates a dynamic sinatra app based on the resources and config' do
      expect(app_creator).to receive(:create).with(config)
      described_class.run config
    end

    it 'runs the app' do
      expect(app).to receive(:run!)
      described_class.run config
    end

    context 'if the cache is to be invalidated' do
      let(:config) { Endpointer::Configuration.new }

      before do
        config.invalidate = true
        allow(cacher).to receive(:invalidate)
      end

      it 'invalidates the cache if the option is selected' do
        expect(cacher).to receive(:invalidate)
        described_class.run config
      end
    end
  end

  describe '.app' do

    before do
      described_class.configure do |cfg|
        cfg.invalidate = false
      end
    end

    it 'returns the sinatra application' do
      expect(described_class.app).to eq(app)
    end
  end
end
