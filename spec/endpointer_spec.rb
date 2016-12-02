require 'spec_helper'

describe Endpointer do
  it 'has a version number' do
    expect(Endpointer::VERSION).not_to be nil
  end

  describe '.run' do
    let(:command_line_arguments) { ['--invalidate', '/foo/bar/resources.json'] }
    let(:argument_parser) { double(Endpointer::ArgumentParser) }

    before do
      allow(Endpointer::ArgumentParser).to receive(:new).and_return(argument_parser)
    end

    it 'passes the list of command line options to the parser' do
      expect(argument_parser).to receive(:parse).with(command_line_arguments)
      described_class.run command_line_arguments
    end

    xit 'runs the relevant actions based on the commands' do
      xit
    end
  end
end
