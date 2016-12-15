require 'spec_helper'

describe Endpointer do
  it 'has a version number' do
    expect(Endpointer::VERSION).not_to be nil
  end

  describe '.run' do
    let(:command_line_arguments) { ['--invalidate', '/foo/bar/resources.json'] }
    let(:argument_parser) { double(Endpointer::ArgumentParser) }
    let(:resource1) { Endpointer::Resource.new }
    let(:resource2) { Endpointer::Resource.new }
    let(:resources) { [resource1, resource2] }
    let(:options) { Endpointer::Options.new(invalidate: true) }
    let(:app_creator) { double(:app_creator) }
    let(:app) { double(:app) }

    before do
      allow(Endpointer::ArgumentParser).to receive(:new).with(command_line_arguments).and_return(argument_parser)
      allow(argument_parser).to receive(:parse_resources).and_return(resources)
      allow(argument_parser).to receive(:parse_options).and_return(options)
      allow(Endpointer::AppCreator).to receive(:new).and_return(app_creator)
      allow(app_creator).to receive(:create).and_return(app)
      allow(app).to receive(:run!)
    end

    it 'creates a dynamic sinatra app based on the resources and options' do
      expect(app_creator).to receive(:create).with(resources, options)
      described_class.run command_line_arguments
    end

    it 'runs the app' do
      expect(app).to receive(:run!)
      described_class.run command_line_arguments
    end
  end
end
