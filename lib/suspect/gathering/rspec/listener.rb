module Suspect
  module Gathering
    module RSpec
      ##
      # Depends on RSpec::Core::Reporter notifications.
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
          @storage_appender.append notification.failed_examples
        end
      end
    end
  end
end
