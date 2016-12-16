require 'spec_helper'

describe Endpointer::PerformerFactory do
  let(:method) { :get }

  describe '.create' do
    context 'when a performer exists for the method' do
      it 'returns an instance of the correct performer' do
        expect(described_class.create(method)).to be_a(Endpointer::Performers::Get)
      end
    end

    context 'when a performer doesnt exist' do
      it 'returns an instance of the correct performer' do
        expect {
          described_class.create(:invalid)
        }.to raise_error(Endpointer::Errors::PerformerNotFoundError)
      end
    end
  end
end
