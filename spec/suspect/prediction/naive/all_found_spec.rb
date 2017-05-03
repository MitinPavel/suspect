require 'spec_helper'
require 'suspect/prediction/naive/all_found'
require 'suspect/file_tree/git/snapshot'
require 'suspect/storage/reader'

RSpec.describe Suspect::Prediction::Naive::AllFound do
  describe '#paths' do
    let(:file_tree) do
      instance_double(::Suspect::FileTree::Git::Snapshot,
                      files: %w(/path/to/a.rb /path/to/b.rb /path/to/c.rb /path/to/y_spec.rb /path/to/z_spec.rb),
                      modified_files: [],
                      commit_hash: 'fake_hash',
                      patch: 'fake_patch')
    end
    let(:run_infos) {instance_double(::Suspect::Storage::Reader, foreach: nil)}

    it 'returns an empty array if there is no run infos' do
      allow(file_tree).to receive(:modified_files) { %w(/path/to/b.rb) }

      actual = described_class.new(run_infos, file_tree).paths
      expect(actual).to be_empty
    end

    it 'returns an empty array if there is no modified files' do
      allow(run_infos).to receive(:foreach).and_yield(build_run_info)

      actual = described_class.new(run_infos, file_tree).paths
      expect(actual).to be_empty
    end

    it 'takes run_info into account only if it contains intersecting set of modified files' do
      allow(file_tree).to receive(:modified_files) {%w(/path/to/b.rb)}
      allow(run_infos).to receive(:foreach).and_yield(build_run_info(modified_files: %w(/path/to/a.rb /path/to/b.rb),
                                                                     failed_files: %w(/path/to/z_spec.rb)))

      actual = described_class.new(run_infos, file_tree).paths
      expect(actual).to eq(%w(/path/to/z_spec.rb))
    end

    it "ignores run_infos if modified_files don't intersect" do
      allow(file_tree).to receive(:modified_files) {%w(/path/to/c.rb)}
      allow(run_infos).to receive(:foreach).and_yield(build_run_info(modified_files: %w(/path/to/a.rb /path/to/b.rb),
                                                                     failed_files: %w(/path/to/z_spec.rb)))

      actual = described_class.new(run_infos, file_tree).paths
      expect(actual).to be_empty
    end

    it 'ignores already deleted spec files' do
      allow(file_tree).to receive(:modified_files) {%w(/path/to/a.rb)}
      allow(file_tree).to receive(:files) { %w(/path/to/a.rb /path/to/z_spec.rb) }
      allow(run_infos).to receive(:foreach).and_yield(build_run_info(modified_files: %w(/path/to/a.rb),
                                                                     failed_files: %w(/path/to/y_spec.rb /path/to/z_spec.rb)))

      actual = described_class.new(run_infos, file_tree).paths
      expect(actual).to_not include('/path/to/y_spec.rb')
    end

    def build_run_info(members = {})
      ::Suspect::Gathering::RunInfo.new.tap do |run_info|
        members.each do |k, v|
          run_info.public_send "#{k}=", v
        end
      end
    end
  end
end
