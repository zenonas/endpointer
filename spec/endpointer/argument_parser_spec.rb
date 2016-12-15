require 'spec_helper'

describe Endpointer::ArgumentParser do
  describe'#parse'do
    let(:command_line_arguments) { ['--invalidate', '/foo/bar/resources.json'] }

    before do
      allow(Endpointer::ActionCommandFactory).to receive(:create).and_return(:action_cmd)
      allow(Endpointer::FileCommand).to receive(:new).and_return(:file_cmd)
    end
    it 'creates commands depending on each recognized argument' do
      expect(subject.parse(command_line_arguments).count).to eq(2)
    end

    it 'only returns the correct commands' do
      expect(subject.parse(command_line_arguments).first).to eq(:action_cmd)
      expect(subject.parse(command_line_arguments).last).to eq(:file_cmd)
    end
  end
end
