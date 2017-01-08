require 'spec_helper'

describe Endpointer do
  it 'has a version number' do
    expect(Endpointer::VERSION).not_to be nil
  end

  let(:command_line_arguments) { ['--invalidate', '/foo/bar/resources.json'] }
  let(:argument_parser) { double(Endpointer::ArgumentParser) }
  let(:resource1) { Endpointer::Resource.new }
  let(:resource2) { Endpointer::Resource.new }
  let(:resources) { [resource1, resource2] }
  let(:options) { Endpointer::Options.new(false) }
  let(:app_creator) { double(:app_creator) }
  let(:app) { double(:app) }
  let(:cacher) { double(:cacher) }

  before do
    allow(Endpointer::ArgumentParser).to receive(:new).with(command_line_arguments).and_return(argument_parser)
    allow(argument_parser).to receive(:parse_resources).and_return(resources)
    allow(argument_parser).to receive(:parse_options).and_return(options)
    allow(argument_parser).to receive(:valid?).and_return(true)
    allow(Endpointer::AppCreator).to receive(:new).and_return(app_creator)
    allow(app_creator).to receive(:create).and_return(app)
    allow(Endpointer::Cacher).to receive(:new).with(options.cache_dir).and_return(cacher)
    allow(app).to receive(:run!)
  end

  describe '.run' do
    it 'creates a dynamic sinatra app based on the resources and options' do
      expect(app_creator).to receive(:create).with(resources, options)
      described_class.run command_line_arguments
    end

    it 'runs the app' do
      expect(app).to receive(:run!)
      described_class.run command_line_arguments
    end

    context 'if the cache is to be invalidated' do
      let(:options) { Endpointer::Options.new(true) }

      before do
        allow(cacher).to receive(:invalidate)
      end

      it 'invalidates the cache if the option is selected' do
        expect(cacher).to receive(:invalidate)
        described_class.run command_line_arguments
      end
    end

    context 'if the arguments are invalid' do

      before do
        allow(argument_parser).to receive(:valid?).and_return(false)
      end

      it 'raises an error' do
        expect {
          described_class.run command_line_arguments
        }.to raise_error(Endpointer::Errors::InvalidArgumentsError)
      end
    end
  end

  describe '.app' do

    it 'returns the sinatra application' do
      expect(described_class.app(command_line_arguments)).to eq(app)
    end

  end
end
