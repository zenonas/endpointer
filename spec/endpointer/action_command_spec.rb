require 'spec_helper'
require 'tempfile'
require 'json'

describe Endpointer::ActionCommand do
  describe '.new' do
    let(:argument) { '--invalidate' }

    context 'when the argument is: --invalidate' do
      it 'sets the :invalidate_caches action' do
        subject = described_class.new argument
        expect(subject.action).to eq :invalidate_caches
      end

      it 'sets the resource_action? to true' do
        subject = described_class.new argument
        expect(subject.resource_action?).to be_truthy
      end
    end

    context 'when the argument is: --debug' do
      let(:argument) { '--debug' }

      it 'sets the :debug action' do
        subject = described_class.new argument
        expect(subject.action).to eq :debug
      end

      it 'sets the resource_action? to true' do
        subject = described_class.new argument
        expect(subject.resource_action?).to be_truthy
      end
    end

    context 'when the argument is: --invalid' do
      let(:argument) { '--invalid' }

      it 'raises an InvalidArgumentError' do
        expect {
          described_class.new argument
        }.to raise_error(Endpointer::InvalidArgumentError)
      end
    end

    it 'sets the action? to true' do
      subject = described_class.new argument
      expect(subject.action?).to be_truthy
    end
  end
end
