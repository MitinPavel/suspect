require 'spec_helper'
require 'suspect/storage/reader'

RSpec.describe Suspect::Storage::Reader do
  describe '#foreach' do
    let(:file_helper) {instance_double(::Suspect::FileUtils::Idempotent)}
    let(:subject) {described_class.new('.', file_helper)}

    it 'yields found run_infos' do
      allow(file_helper).to receive(:file_paths) {['/path/to/storage/file.suspect']}
      allow(file_helper).to receive(:read).with('/path/to/storage/file.suspect').and_yield("{\"collector_id\":\"fake_id\"}")

      yielded = []
      subject.foreach {|i| yielded << i}
      expect(yielded).to eq([::Suspect::Gathering::RunInfo.new('fake_id')])
    end

    it 'does nothing if no storage files found' do
      allow(file_helper).to receive(:file_paths) {[]}

      subject.foreach {|_| fail 'I should not be called'}
    end

    it "ignores a file if it doesn't end with .suspect" do
      allow(file_helper).to receive(:file_paths) {['/path/to/storage/file.suspect.zip']}

      expect(file_helper).to receive(:read).never
      subject.foreach {|_| fail 'I should not be called'}
    end
  end
end
