require 'spec_helper'
require 'tempfile'
require 'endpointer/argument_parser'

describe Endpointer::ArgumentParser do
  let(:tempfile) { Tempfile.new }

  let(:cache_path) { '/some/path' }
  let(:some_config_file) { 'some config' }

  describe'#parse'do
    before do
      File.write(tempfile.path, some_config_file)
    end

    context 'cache-dir option' do
      let(:command_line_arguments) { ["--cache-dir=#{cache_path}"] }

      it 'sets the cache dir to the specified dir' do
        expect(subject.parse(command_line_arguments).cache_dir).to eq(cache_path)
      end

      context 'when the cache path in not set' do
        let(:command_line_arguments) { [] }

        it 'leaves the default' do
          expect(subject.parse(command_line_arguments).cache_dir).to eq(Endpointer::Configuration.new.cache_dir)
        end
      end
    end

    context 'invalidate' do
      let(:command_line_arguments) { ["--invalidate"] }

      it 'sets the invalidate option' do
        expect(subject.parse(command_line_arguments).invalidate).to be_truthy
      end
    end

    context 'input config file' do
      let(:command_line_arguments) { ["--config=#{tempfile.path}"] }

      it 'reads the config and sets it on the configuration' do
        expect(subject.parse(command_line_arguments).resource_config).to eq(some_config_file)
      end

      context 'when the config supplied doesnt exist' do
        let(:command_line_arguments) { ["--config=/foo/bar"] }

        it 'outputs a message to stderr' do
          begin
            expect {
              subject.parse(command_line_arguments)
            }.to output("Error: Config file supplied does not exist").to_stderr
          rescue SystemExit
          end

        end
      end
    end

    context 'invalid argument' do
      let(:command_line_arguments) { ["--something"] }
      it 'outputs a message to stderr' do
        begin
          expect {
            subject.parse(command_line_arguments)
          }.to output("Error: invalid option --something").to_stderr
        rescue SystemExit
        end

      end
    end

  end

  after do
    tempfile.delete
  end
end
