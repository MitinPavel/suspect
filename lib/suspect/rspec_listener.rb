require 'pathname'
require 'time'

require_relative './file_utils/idempotent'
require_relative './setup/collector_id_generator'
require_relative './setup/structure'
require_relative './setup/creator'
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
      return unless supported_platform?

      structure = build_structure
      listener = build_listener(structure)

      reporter.register_listener listener, *listener.notification_names
    end

    private

    def build_structure
      root_path = ::Pathname.new('.')
      file_helper = ::Suspect::FileUtils::Idempotent.new
      structure = ::Suspect::Setup::Structure.new(root_path)
      collector_id_generator = ::Suspect::Setup::CollectorIdGenerator.new
      ::Suspect::Setup::Creator.new(structure, collector_id_generator, file_helper).build

      structure
    end

    def build_listener(structure)
      storage_path = ::Suspect::Storage::DirPath.new(structure.storage_path, Time.now.utc)
      file_helper = ::Suspect::FileUtils::Idempotent.new
      collector_id = file_helper.read(structure.collector_id_path)
      storage = ::Suspect::Storage::Appender.new(dir_path: storage_path, dir_helper: file_helper, collector_id: collector_id)
      file_tree = ::Suspect::FileTree::Git::Snapshot.new

      ::Suspect::Gathering::RSpec::Listener.new(file_tree, storage, collector_id, ::Time.now.utc)
    end

    def supported_platform?
      ::Gem::Platform.local.os == 'linux'
    end
  end
end
