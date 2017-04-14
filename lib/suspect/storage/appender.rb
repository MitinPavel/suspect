require 'fileutils'

require_relative './../file_utils/flock_writer'

module Suspect
  module Storage
    class Appender
      VERSION = '1'

      def initialize(opts)
        @writer = opts[:writer] || ::Suspect::FileUtils::FlockWriter.new
        @dir_helper = opts[:dir_helper] ||fail(ArgumentError, 'No dir_helper found')
        @dir_path = opts[:dir_path] || fail(ArgumentError, 'No dir_path found')
        @collector_id = opts[:collector_id] || fail(ArgumentError, 'No collector_id found')
      end

      def append(run_info)
        dir_helper.mkdir dir_path.expand_path

        writer.write filename,
                     run_info.to_s
      end

      private

      attr_reader :writer, :dir_helper, :dir_path, :collector_id

      def filename
        "#{dir_path.expand_path}/#{collector_id}-#{VERSION}.ss"
      end
    end
  end
end
