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
          run_info = build_run_info(file_paths: file_paths(notification))

          if run_info.failed_files.any?
            @storage_appender.append run_info
          end
        end

        private

        def build_run_info(file_paths:)
          ::Suspect::Gathering::RunInfo.new.tap do |info|
            info.failed_files = file_paths
          end
        end

        def file_paths(notification)
          notification.failed_examples.map(&:file_path)
        end
      end
    end
  end
end
