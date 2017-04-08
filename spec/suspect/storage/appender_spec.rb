require 'spec_helper'
require 'suspect/storage/appender'

RSpec.describe Suspect::Storage::Appender do
  describe '#append' do
    before { allow(FileUtils).to receive :mkdir_p }

    let(:run_info) { instance_double(::Suspect::Gathering::RunInfo, to_s: 'serialized run info', commit_hash: 'hash') }
    let(:writer) { instance_double(::Suspect::Storage::FlockWriter) }

    it 'appends serialized run info' do
      expect(writer).to receive(:write).with anything, 'serialized run info'

      appender = described_class.new(path: '.', writer: writer)
      appender.append run_info
    end

    it 'compose a  storage file path concatenating the passed path and the current commit hash' do
      expect(writer).to receive(:write).with '/a/path/to/store/hash', anything

      appender = described_class.new(path: '/a/path/to/store', writer: writer)
      appender.append run_info
    end
  end
end
