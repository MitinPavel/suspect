require 'spec_helper'
require 'suspect/gathering/rspec/listener'
require 'suspect/storage/appender'
require 'suspect/file_tree/git/snapshot'

module StorageAppenderHelpers
  extend ::RSpec::Matchers::DSL

  matcher :append_to  do |appender|
    match do |actual|
      expect(appender).to receive(:append).with(instance_of(::Suspect::Gathering::RunInfo)) do |run_info|
        @expected_run_info_data.each do |attribute, value|
          expect(run_info.public_send(attribute)).to eq(value)
        end
      end

      actual.call

      true
    end

    chain(:with) do |options|
      @expected_run_info_data = options
    end

    def supports_block_expectations?
      true
    end
  end
end

RSpec.describe Suspect::Gathering::RSpec::Listener do
  let(:file_tree) { instance_double(::Suspect::FileTree::Git::Snapshot, modified_files: []) }
  let(:storage_appender) { instance_double(::Suspect::Storage::Appender) }

  describe '#stop' do
    include StorageAppenderHelpers

    let(:listener) { described_class.new(file_tree, storage_appender) }

    it 'stores file paths of failed examples' do
      expect do
        listener.stop examples_notification(failed_files: %w(/path/to/a_spec.rb /path/to/b_spec.rb))
      end.to append_to(storage_appender).with failed_files: %w(/path/to/a_spec.rb /path/to/b_spec.rb)
    end

    it 'stores file paths of modified files' do
      allow(file_tree).to receive(:modified_files) { %w(/path/to/a.rb /path/to/b.rb) }

      expect do
        listener.stop examples_notification
      end.to append_to(storage_appender).with modified_files: %w(/path/to/a.rb /path/to/b.rb)
    end

    context '[no failed examples]' do
      let(:storage_appender) { instance_double(::Suspect::Storage::Appender) }

      it 'does nothing if no failed examples' do
        listener.stop examples_notification(failed_files: [])
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
      listener = described_class.new(file_tree, storage_appender)
      expect(listener.notification_names).to eq(%i(stop))
    end
  end
end
