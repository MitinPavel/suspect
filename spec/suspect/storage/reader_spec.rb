require 'spec_helper'
require 'suspect/storage/reader'

RSpec.describe Suspect::Storage::Reader do
  describe '#foreach' do
    let(:file_helper) {instance_double(::Suspect::FileUtils::Idempotent)}
    let(:subject) {described_class.new('.', file_helper)}

    it 'yields found run_infos' do
      run_info = ::Suspect::Gathering::RunInfo.new('fake_collector_id')
      allow(file_helper).to receive(:file_paths) {['/path/to/storage/file.ss']}
      allow(file_helper).to receive(:read).with('/path/to/storage/file.ss').and_yield(run_info.to_json)

      yielded = []
      subject.foreach {|i| yielded << i}
      expect(yielded).to eq([run_info])
    end

    it 'does nothing if no storage files found' do
      allow(file_helper).to receive(:file_paths) {[]}

      subject.foreach {|_| fail 'I should not be called'}
    end

    it "ignores a file if it doesn't end with .ss" do
      allow(file_helper).to receive(:file_paths) {['/path/to/storage/file.zip']}

      expect(file_helper).to receive(:read).never
      subject.foreach {|_| fail 'I should not be called'}
    end
  end
end
