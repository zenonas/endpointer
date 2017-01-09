require 'spec_helper'

describe Endpointer::Cacher do
  let(:resource) { Endpointer::Resource.new('some_resource', :get, 'http://example.com', {'foo' => 'bar'}) }
  let(:response) { Endpointer::Response.new(200, 'some body', {'baz' => 'crux'}) }
  let(:timestamp) { Time.now.utc }

  let(:cache_container) { Endpointer::CacheContainer.new(resource, response, timestamp) }

  let(:tempdir) { Dir.mktmpdir }

  subject { described_class.new(tempdir) }

  describe '#get' do
    context 'when a resource file is found' do
      before do
        File.write(File.join(tempdir, "#{resource.id}.yml"), YAML.dump(cache_container))
      end
      it 'returns the response' do
        expect(subject.get(resource)).to eq(response)
      end

      context 'but the resource cached doesnt match' do
        let(:slightly_different_resource) do
          new = resource.dup
          new.url = "http://something.com"
          new
        end

        it 'raises a CachedItemNotFoundError' do
          expect {
            subject.get(slightly_different_resource)
          }.to raise_error(Endpointer::Errors::CachedItemNotFoundError)
        end
      end
    end

    context 'when a resource is not found' do
      let(:resource) { Endpointer::Resource.new('another_resource') }

      it 'raises a CachedItemNotFoundError' do
          expect {
            subject.get(resource)
          }.to raise_error(Endpointer::Errors::CachedItemNotFoundError)
      end
    end
  end

  describe '#set' do
    context 'when the cache dir doesnt exist' do
      before do
        FileUtils.remove_entry(tempdir)
      end

      context 'when it cant create it' do
        let(:invalid_cache_path) { '/foo/bar' }

        it "raises an error" do
          expect {
            described_class.new(invalid_cache_path)
          }.to raise_error(Endpointer::Errors::InvalidCacheDirError)
        end

      end

      it 'creates it' do
        described_class.new(tempdir)
        expect(File.exists?(tempdir)).to be_truthy
      end
    end

    context 'when the cache dir exists' do
      it 'stores the response in the cache dir as a yaml dump' do
        subject.set(resource, response)
        cached_response = YAML.load(File.read(File.join(tempdir, "#{resource.id}.yml")))
        expect(cached_response.response).to eq(response)
      end
    end
  end

  describe '#invalidate' do

    before do
      FileUtils.touch(File.join(tempdir, "test1"))
    end

    it 'deletes the contents of the cache dir' do
      subject.invalidate
      expect(Dir.glob(File.join(tempdir, '*'))).to be_empty
      expect(File.exists?(tempdir)).to be_truthy
    end
  end

  after do
    FileUtils.remove_entry(tempdir) if File.exists?(tempdir)
  end
end
