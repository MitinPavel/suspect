require 'spec_helper'
require_relative '../../../support/matchers/storage_appender_matchers'
require 'suspect/file_tree/git/snapshot'
require 'suspect/storage/appender'

RSpec.describe Suspect::Gathering::RSpec::Listener do
  let(:file_tree) do
    instance_double(::Suspect::FileTree::Git::Snapshot,
                    branch: 'master',
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

    context '[VCS branch]' do
      it 'stores the current git branch' do
        allow(file_tree).to receive(:branch) { 'feature_42' }

        expect do
          listener.stop examples_notification
        end.to append_to(storage_appender).with branch: 'feature_42'
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

    context '[counts]' do
      context '[failed example count]' do
        it 'calculates each individual example taking duplication into account' do
          expect do
            listener.stop examples_notification(failed_files: %w(a_spec.rb a_spec.rb a_spec.rb b_spec.rb))
          end.to append_to(storage_appender).with failed_example_count: 4
        end
      end

      context '[pending example count]' do
        it 'stores 0 if no pending examples' do
          expect do
            listener.stop examples_notification(pending_files: [])
          end.to append_to(storage_appender).with pending_example_count: 0
        end

        it 'calculates each individual example taking duplication into account' do
          expect do
            listener.stop examples_notification(pending_files: %w(a_spec.rb a_spec.rb a_spec.rb b_spec.rb))
          end.to append_to(storage_appender).with pending_example_count: 4
        end
      end

      context '[successful example count]' do
        it 'calculates it as the difference between all example count and failed/pending example count' do
          failed_examples = %w(/path/to/a_spec.rb).map { |p| example_by(p) }
          pending_examples = %w(/path/to/a_spec.rb).map { |p| example_by(p) }
          examples =  %w(/path/to/a_spec.rb /path/to/a_spec.rb /path/to/a_spec.rb).map { |p| example_by(p) }

          expect do
            listener.stop instance_double(::RSpec::Core::Notifications::ExamplesNotification,
                                          failed_examples: failed_examples,
                                          pending_examples: pending_examples,
                                          examples: examples)
          end.to append_to(storage_appender).with successful_example_count: 1
        end
      end
    end

    def examples_notification(failed_files: %w(/path/to/a_spec.rb), pending_files: [], successful_files: [])
      failed_examples = failed_files.map { |p| example_by(p) }
      pending_examples =  pending_files.map  { |p| example_by(p) }
      successful_examples =  successful_files.map  { |p| example_by(p) }

      instance_double(::RSpec::Core::Notifications::ExamplesNotification,
                      failed_examples: failed_examples,
                      pending_examples: pending_examples,
                      examples: failed_examples + pending_examples + successful_examples)
    end

    def example_by(file_path)
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
