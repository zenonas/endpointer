require 'spec_helper'
require 'endpointer/command'

describe Endpointer::ArgumentParser do
  describe'#parse'do
    let(:command_line_arguments) { ['--invalidate', '/foo/bar/resources.json'] }

    it 'creates commands depending on each recognized argument' do
      expect(subject.parse(command_line_arguments).count).to eq(2)
    end

    it 'only returns command classes' do
      expect(subject.parse(command_line_arguments).first).to be_a(Endpointer::Command)
      expect(subject.parse(command_line_arguments).last).to be_a(Endpointer::Command)
    end
  end
end