require 'spec_helper'
require 'suspect/gathering/rspec/listener'
require 'suspect/storage/appender'
require 'suspect/file_tree/git/snapshot'

RSpec.describe Suspect::Gathering::RSpec::Listener do
  let(:file_tree) { instance_double(::Suspect::FileTree::Git::Snapshot, modified_files: []) }
  let(:storage_appender) { instance_double(::Suspect::Storage::Appender) }

  describe '#notification_names' do
    it 'is only interested in "stop" notification' do
      listener = described_class.new(file_tree, storage_appender)
      expect(listener.notification_names).to eq(%i(stop))
    end
  end

  describe '#stop' do
    let(:listener) { described_class.new(file_tree, storage_appender) }

    it 'stores file paths of failed examples' do
      expect(storage_appender).to receive(:append) do |run_info|
        expect(run_info.failed_files).to eq(%w(/path/to/a_spec.rb /path/to/b_spec.rb))
      end

      listener.stop examples_notification(failed_files: %w(/path/to/a_spec.rb /path/to/b_spec.rb))
    end

    it 'stores file paths of modified files' do
      allow(file_tree).to receive(:modified_files) { %w(/path/to/a.rb /path/to/b.rb) }

      expect(storage_appender).to receive(:append) do |run_info|
        expect(run_info.modified_files).to eq(%w(/path/to/a.rb /path/to/b.rb))
      end

      listener.stop examples_notification(failed_files: %w(/path/to/a_spec.rb))
    end

    context '[no failed examples]' do
      let(:storage_appender) { instance_double(::Suspect::Storage::Appender) }

      it 'does nothing if no failed examples' do
        listener.stop examples_notification(failed_files: [])
      end
    end

    def examples_notification(failed_files: [])
      instance_double(::RSpec::Core::Notifications::ExamplesNotification,
                      failed_examples: failed_files.map { |p| example(p) })
    end

    def example(file_path)
      instance_double(::RSpec::Core::Example,
                      file_path: file_path)
    end
  end
end
