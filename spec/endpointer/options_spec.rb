require 'spec_helper'

describe Endpointer::Options do
  describe '.new' do
    it 'initializes to the defaults' do
      options = described_class.new
      expect(options.invalidate).to be_falsey
      expect(options.cache_dir).to eq(File.join(Dir.tmpdir, "endpointer_cache"))
    end

    context 'when initialized with arguments' do
      let(:cache_dir) { '/foo/bar' }

      it 'uses those arguments' do
        options = described_class.new(true, cache_dir)
        expect(options.invalidate).to be_truthy
        expect(options.cache_dir).to eq(cache_dir)
      end
    end
  end
end
