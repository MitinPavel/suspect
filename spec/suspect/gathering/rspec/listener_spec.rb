require 'spec_helper'
require 'suspect/gathering/rspec/listener'
require 'suspect/storage/appender'
require 'suspect/file_tree/git/snapshot'

module StorageAppenderHelpers
  extend ::RSpec::Matchers::DSL

  matcher :append_to  do |appender|
    match do |actual|
      expect(appender).to receive(:append).with(instance_of(::Suspect::Gathering::RunInfo)) do |info|
        @actual_run_info = info
      end

      actual.call

      if @actual_run_info
        erroneous = @expected_run_info_data.select { |attr, value| @actual_run_info.public_send(attr) != value }

        if erroneous.empty?
          true
        else
          @failure_message = "expected #{@actual_run_info} to include #{@expected_run_info_data}"
          false
        end
      else
        true # Mocking for #append handles the failure.
      end
    end

    chain :with do |options|
      @expected_run_info_data = options
    end

    failure_message do
      @failure_message
    end

    def supports_block_expectations?
      true
    end
  end
end

RSpec.describe Suspect::Gathering::RSpec::Listener do
  let(:file_tree) { instance_double(::Suspect::FileTree::Git::Snapshot, modified_files: [], commit_hash: 'fake_hash') }
  let(:storage_appender) { instance_double(::Suspect::Storage::Appender) }

  describe '#stop' do
    include StorageAppenderHelpers

    let(:listener) { described_class.new(file_tree, storage_appender) }

    context '[commit hash]' do
      it 'stores a hash of the current git commit' do
        allow(file_tree).to receive(:commit_hash) { 'c037805ab7f514c9eq7838eb4f702af0fd1f0e62' }

        expect do
          listener.stop examples_notification
        end.to append_to(storage_appender).with commit_hash: 'c037805ab7f514c9eq7838eb4f702af0fd1f0e62'
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
      listener = described_class.new(file_tree, storage_appender)
      expect(listener.notification_names).to eq(%i(stop))
    end
  end
end
