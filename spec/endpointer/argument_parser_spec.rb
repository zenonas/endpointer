require 'spec_helper'
require 'tempfile'

describe Endpointer::ArgumentParser do
  let(:tempfile) { Tempfile.new }
  let(:command_line_arguments) { ['--invalidate', tempfile.path] }

  subject { Endpointer::ArgumentParser.new(command_line_arguments) }

  let(:url1) { "http://example.com/foo" }
  let(:url2) { "http://example.com/bar" }
  let(:header1) { { "Authorization" => "Bearer foo" } }
  let(:header2) { { "Authorization" => "Bearer bar" } }

  describe'#parse_resources'do
    let(:config) do
      [
        {
          method: :get,
          url: url1,
          headers: header1
        },
        {
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
      expect(subject.parse_resources.first.method).to eq(:get)
      expect(subject.parse_resources.first.url).to eq(url1)
      expect(subject.parse_resources.first.headers).to eq(header1)
      expect(subject.parse_resources.last.method).to eq(:post)
      expect(subject.parse_resources.last.url).to eq(url2)
      expect(subject.parse_resources.last.headers).to eq(header2)
    end
  end

  describe "#parse_options" do
    it 'returns the correctly configured options' do
      expect(subject.parse_options.invalidate).to be_truthy
    end
  end

  after do
    tempfile.delete
  end
end
