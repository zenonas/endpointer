require 'spec_helper'
require 'tempfile'
require 'json'

describe Endpointer::ActionCommandFactory do
  describe '.create' do
    let(:argument) { '--invalidate' }

    context 'when the argument is: --invalidate' do
      it 'creates an invalidate action' do
        expect(described_class.create argument).to be_a(Endpointer::ActionCommands::InvalidateCache)
      end
    end

    context 'when the argument is: --invalid' do
      let(:argument) { '--invalid' }

      it 'raises an InvalidArgumentError' do
        expect {
          described_class.create argument
        }.to raise_error(Endpointer::InvalidArgumentError)
      end
    end
  end
end
