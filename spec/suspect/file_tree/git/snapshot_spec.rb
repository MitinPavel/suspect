require 'spec_helper'
require 'suspect/file_tree/git/snapshot'
require 'suspect/file_tree/git/client'

RSpec.describe Suspect::FileTree::Git::Snapshot do
  let(:git_client) { instance_double(::Suspect::FileTree::Git::Client, modified_files: '', commit_hash: 'fake_hash') }

  describe '#modified_files' do
    it 'returns an empty array if no modified files' do
      snapshot = described_class.new(git_client)
      expect(snapshot.modified_files).to eq([])
    end

    it 'returns an array of file paths' do
      allow(git_client).to receive(:modified_files) { "path/to/a.rb\npath/to/b.rb\n" }

      snapshot = described_class.new(git_client)
      expect(snapshot.modified_files).to match_array(%w(path/to/a.rb path/to/b.rb))
    end
  end

  describe '#commit_hash' do
    it 'returns a hash of the current Git commit' do
      allow(git_client).to receive(:commit_hash) { "0f5be4d1026ab101aac70edae10911d127b70b86\n" }

      snapshot = described_class.new(git_client)
      expect(snapshot.commit_hash).to eq('0f5be4d1026ab101aac70edae10911d127b70b86')
    end
  end
end
