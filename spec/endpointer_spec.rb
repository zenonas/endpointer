require 'spec_helper'

describe Endpointer do
  it 'has a version number' do
    expect(Endpointer::VERSION).not_to be nil
  end

  describe '.run' do
    let(:command_line_arguments) { ['--invalidate', '/foo/bar/resources.json'] }
    let(:argument_parser) { double(Endpointer::ArgumentParser) }
    let(:command1) { Endpointer::ActionCommands::FakeAction.new }
    let(:command2) { double(Endpointer::FileCommand) }
    let(:commands) { [command1, command2] }

    before do
      allow(Endpointer::ArgumentParser).to receive(:new).and_return(argument_parser)
      allow(argument_parser).to receive(:parse).and_return(commands)
    end

    it 'passes the list of command line options to the parser' do
      expect(argument_parser).to receive(:parse).with(command_line_arguments)
      described_class.run command_line_arguments
    end

    it 'runs the relevant action commands based on the commands' do
      expect(command1).to receive(:run)
      described_class.run command_line_arguments
    end
  end
end

class Endpointer::ActionCommands::FakeAction < Endpointer::ActionCommand
  def run; end
end
