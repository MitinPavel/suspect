require 'spec_helper'
require 'suspect/gathering/rspec/listener'

RSpec.describe Suspect::Gathering::RSpec::Listener do
  let(:file_tree) { double('file_tree') }
  let(:storage_appender) { double('storage_appender') }

  describe '#notification_names' do
    it 'is only interested in "stop" notification' do
      listener = described_class.new(file_tree, storage_appender)
      expect(listener.notification_names).to eq(%i(stop))
    end
  end

  describe '#stop' do
    let(:listener) { described_class.new(file_tree, storage_appender) }

    it 'stores test run results' do
      examples_notification = instance_double(::RSpec::Core::Notifications::ExamplesNotification,
                                              failed_examples: [:some_spec_run_info])

      expect(storage_appender).to receive :append

      listener.stop examples_notification
    end
  end
end
