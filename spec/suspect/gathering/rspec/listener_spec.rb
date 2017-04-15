require 'spec_helper'
require_relative '../../../support/matchers/storage_appender_matchers'
require 'suspect/file_tree/git/snapshot'
require 'suspect/storage/appender'

RSpec.describe Suspect::Gathering::RSpec::Listener do
  let(:file_tree) do
    instance_double(::Suspect::FileTree::Git::Snapshot,
                    modified_files: [],
                    commit_hash: 'fake_hash',
                    patch: 'fake_patch')
  end
  let(:storage_appender) { instance_double(::Suspect::Storage::Appender) }
  let(:collector_id) { 'abcd1234' }
  let(:clock) { instance_double(::Time, iso8601: '2017-04-15T11:57:27Z') }

  describe '#stop' do
    include StorageAppenderMatchers

    let(:listener) { described_class.new(file_tree, storage_appender, collector_id, clock) }

    context '[collector_id]' do
      it 'stores collector_id' do
        expect do
          listener.stop examples_notification
        end.to append_to(storage_appender).with collector_id: 'abcd1234'
      end
    end

    context '[notified_at]' do
      it 'stores collector_id' do
        expect do
          listener.stop examples_notification
        end.to append_to(storage_appender).with notified_at: '2017-04-15T11:57:27Z'
      end
    end

    context '[commit hash]' do
      it 'stores a hash of the current git commit' do
        allow(file_tree).to receive(:commit_hash) { 'c037805ab7f514c9eq7838eb4f702af0fd1f0e62' }

        expect do
          listener.stop examples_notification
        end.to append_to(storage_appender).with commit_hash: 'c037805ab7f514c9eq7838eb4f702af0fd1f0e62'
      end
    end

    context '[version control system patch]' do
      it 'stores a patch string of the current file tree' do
        allow(file_tree).to receive(:patch) { 'fake patch string' }

        expect do
          listener.stop examples_notification
        end.to append_to(storage_appender).with patch: 'fake patch string'
      end
    end

    context '[modified files]' do
      it 'stores file paths of modified files' do
        allow(file_tree).to receive(:modified_files) { %w(/path/to/a.rb /path/to/b.rb) }

        expect do
          listener.stop examples_notification
        end.to append_to(storage_appender).with modified_files: %w(/path/to/a.rb /path/to/b.rb)
      end
    end

    context '[files with failed examples]' do
      it 'stores file paths of failed examples' do
        expect do
          listener.stop examples_notification(failed_files: %w(/path/to/a_spec.rb))
        end.to append_to(storage_appender).with failed_files: %w(/path/to/a_spec.rb)
      end

      it 'removes path duplicates' do
        expect do
          listener.stop examples_notification(failed_files: %w(/path/to/a_spec.rb /path/to/a_spec.rb /path/to/b_spec.rb))
        end.to append_to(storage_appender).with failed_files: %w(/path/to/a_spec.rb /path/to/b_spec.rb)
      end

      it 'sorts file paths' do
        expect do
          listener.stop examples_notification(failed_files: %w(/path/to/c.rb /path/to/a.rb /path/to/b.rb))
        end.to append_to(storage_appender).with failed_files: %w(/path/to/a.rb /path/to/b.rb /path/to/c.rb)
      end

      context '[no failed examples]' do
        let(:storage_appender) { instance_double(::Suspect::Storage::Appender) }

        it 'does nothing if no failed examples' do
          listener.stop examples_notification(failed_files: [])
        end
      end
    end

    def examples_notification(failed_files: %w(/path/to/a_spec.rb))
      instance_double(::RSpec::Core::Notifications::ExamplesNotification,
                      failed_examples: failed_files.map { |p| example(p) })
    end

    def example(file_path)
      instance_double(::RSpec::Core::Example,
                      file_path: file_path)
    end
  end

  describe '#notification_names' do
    it 'is only interested in "stop" notification' do
      listener = described_class.new(file_tree, storage_appender, collector_id, clock)
      expect(listener.notification_names).to eq(%i(stop))
    end
  end
end
