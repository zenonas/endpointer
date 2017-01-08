require 'spec_helper'
require 'tempfile'

describe Endpointer::ArgumentParser do
  let(:tempfile) { Tempfile.new }
  let(:command_line_arguments) { ['--invalidate', tempfile.path] }

  subject { Endpointer::ArgumentParser.new(command_line_arguments) }

  let(:id1) { 'foo' }
  let(:id2) { 'bar' }
  let(:url1) { "http://example.com/foo" }
  let(:url2) { "http://example.com/bar" }
  let(:header1) { { "Authorization" => "Bearer foo" } }
  let(:header2) { { "Authorization" => "Bearer bar" } }
  let(:cache_path) { '/some/path' }

  describe'#parse_resources'do
    let(:config) do
      [
        {
          id: id1,
          method: :get,
          url: url1,
          headers: header1
        },
        {
          id: id2,
          method: :post,
          url: url2,
          headers: header2
        }
      ]
    end

    before do
      File.write(tempfile.path, JSON.generate(config))
    end

    it 'provides a list of resources' do
      expect(subject.parse_resources.count).to eq(2)
      expect(subject.parse_resources.first.id).to eq(id1)
      expect(subject.parse_resources.first.method).to eq(:get)
      expect(subject.parse_resources.first.url).to eq(url1)
      expect(subject.parse_resources.first.headers).to eq(header1)
      expect(subject.parse_resources.last.id).to eq(id2)
      expect(subject.parse_resources.last.method).to eq(:post)
      expect(subject.parse_resources.last.url).to eq(url2)
      expect(subject.parse_resources.last.headers).to eq(header2)
    end
  end

  describe "#parse_options" do
    context 'cache-dir option' do
      let(:command_line_arguments) { ["--cache-dir=#{cache_path}", tempfile.path] }

      it 'sets the cache dir to the specified dir' do
        expect(subject.parse_options.cache_dir).to eq(cache_path)
      end
    end

    context 'invalidate' do
      it 'returns the correctly configured options' do
        expect(subject.parse_options.invalidate).to be_truthy
      end
    end
  end

  describe "#validate_arguments" do
    context "when the arguments are valid" do
      let(:command_line_arguments) { ["--cache-dir=#{cache_path}", tempfile.path] }

      it "returns true" do
        expect(subject.valid?).to be_truthy
      end
    end

    context "when all arguments are invalid" do
      let(:command_line_arguments) { ['--something'] }

      it "returns false" do
        expect(subject.valid?).to be_falsey
      end
    end

    context "when some arguemnts are invalid" do
      let(:command_line_arguments) { ['--invalid', tempfile.path] }

      it "returns false" do
        expect(subject.valid?).to be_falsey
      end

    end
  end

  after do
    tempfile.delete
  end
end
