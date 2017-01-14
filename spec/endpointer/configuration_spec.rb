require 'spec_helper'

describe Endpointer::Configuration do
  let(:some_config_file) { 'some config' }
  let(:config_file_path) { './endpointer.json' }

  before do
    File.write(config_file_path, some_config_file)
  end

  describe '.new' do
    it 'initializes to the defaults' do
      options = described_class.new
      expect(options.invalidate).to be_falsey
      expect(options.cache_dir).to eq(File.join(Dir.tmpdir, "endpointer_cache"))
      expect(options.resource_config).to eq(some_config_file)
    end

    context 'the default config doesnt exist' do
      before do
        FileUtils.remove_entry(config_file_path)
      end

      it 'sets the config to nil' do
        options = described_class.new
        expect(options.resource_config).to be_nil
      end
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
