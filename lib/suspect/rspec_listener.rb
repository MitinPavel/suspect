require_relative './gathering/rspec/listener'
require_relative './file_tree/git/snapshot'
require_relative './storage/appender'

module Suspect
  ##
  # A facade enabling easy setup:
  #
  #    require 'suspect/rspec_listener'
  #
  #    RSpec.configure do |config|
  #      ::Suspect::RSpecListener.setup_using config
  #
  class RSpecListener
    class << self
      def setup_using(rspec_config)
        new.register_listener rspec_config.reporter
      end
    end

    def register_listener(reporter)
      file_tree = ::Suspect::FileTree::Git::Snapshot.new
      storage = ::Suspect::Storage::Appender.new
      listener = ::Suspect::Gathering::RSpec::Listener.new(file_tree, storage)

      reporter.register_listener listener, *listener.notification_names
    end
  end
end
