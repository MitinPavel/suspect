require 'spec_helper'
require 'pathname'
require 'suspect/storage/appender'

RSpec.describe Suspect::Storage::Appender do
  describe '#append' do

    let(:run_info) { instance_double(::Suspect::Gathering::RunInfo, to_s: 'serialized run info') }
    let(:writer) { instance_double(::Suspect::FileUtils::FlockWriter) }
    let(:dir_helper) { instance_double(::Suspect::FileUtils::Idempotent) }

    before { allow(dir_helper).to receive(:mkdir) }

    it 'appends serialized run info' do
      expect(writer).to receive(:write).with anything, 'serialized run info'

      appender = described_class.new(dir_path: pathname('.'), writer: writer, dir_helper: dir_helper, collector_id: 'some id')
      appender.append run_info
    end

    it 'compose a storage file path concatenating the path, the storage version and the collector id' do
      expect(described_class::VERSION).to eq('1')
      expect(writer).to receive(:write).with '/a/path/to/store/12345-1.ss', anything

      appender = described_class.new(dir_path: pathname('/a/path/to/store'), dir_helper: dir_helper, writer: writer, collector_id: '12345')
      appender.append run_info
    end

    def pathname(path)
      ::Pathname.new(path)
    end
  end
end
