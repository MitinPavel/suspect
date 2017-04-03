require_relative '../run_info'

module Suspect
  module Gathering
    module RSpec
      ##
      # Depends on:
      # * RSpec::Core::Reporter#failed_examples.
      # * RSpec::Core::Example#file_path.
      #
      class Listener
        def initialize(file_tree, storage_appender)
          @file_tree = file_tree
          @storage_appender = storage_appender
        end

        def notification_names
          %i(stop)
        end

        def stop(notification)
          run_info = build_run_info(failed_files: failed_files(notification),
                                    commit_hash: file_tree.commit_hash,
                                    modified_files: file_tree.modified_files)

          if run_info.failed_files.any?
            storage_appender.append run_info
          end
        end

        private

        attr_reader :file_tree, :storage_appender

        def build_run_info(failed_files:, commit_hash:, modified_files:)
          ::Suspect::Gathering::RunInfo.new.tap do |info|
            info.failed_files = failed_files
            info.commit_hash = commit_hash
            info.modified_files = modified_files
          end
        end

        def failed_files(notification)
          notification.failed_examples.map(&:file_path)
        end
      end
    end
  end
end
