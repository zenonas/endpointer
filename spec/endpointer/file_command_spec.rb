require 'spec_helper'
require 'tempfile'
require 'json'

describe Endpointer::FileCommand do
  describe '.new' do
    let(:tempfile) { Tempfile.new }
    let(:content) do
      JSON.generate({
        foo: 'bar'
      })
    end

    before do
      File.write(tempfile.path, content)
    end

    after do
      tempfile.delete
    end

    it 'reads and parses the file passed in' do
      subject = described_class.new tempfile.path
      expect(subject.file['foo']).to eq 'bar'
    end

    it 'sets the file? to true' do
      subject = described_class.new tempfile.path
      expect(subject.file?).to be_truthy
    end
  end
end
