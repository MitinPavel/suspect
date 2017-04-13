require 'pathname'

require_relative './file_utils/idempotent'
require_relative './setup/dir_structure'
require_relative './gathering/rspec/listener'
require_relative './file_tree/git/snapshot'
require_relative './storage/appender'
require_relative './storage/dir_path'

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
      root_path = ::Pathname.new('.')
      file_helper = ::Suspect::FileUtils::Idempotent.new
      dir_structure = ::Suspect::Setup::DirStructure.new(root_path, file_helper).build

      storage_path = ::Suspect::Storage::DirPath.new(dir_structure.storage_path, Time.now.utc)
      storage = ::Suspect::Storage::Appender.new(path: storage_path, collector_id: rand(99999).to_s)
      file_tree = ::Suspect::FileTree::Git::Snapshot.new
      listener = ::Suspect::Gathering::RSpec::Listener.new(file_tree, storage)

      reporter.register_listener listener, *listener.notification_names
    end
  end
end
