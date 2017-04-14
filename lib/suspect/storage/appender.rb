require 'fileutils'

require_relative '../file_utils/flock_writer'
require_relative 'dir_path'

module Suspect
  module Storage
    class Appender
      VERSION = '1'

      def initialize(opts)
        @writer = opts[:writer] || FlockWriter.new
        @path = opts[:path] || fail(ArgumentError, 'No path found')
        @collector_id = opts[:collector_id] || fail(ArgumentError, 'No collector_id found')
      end

      def append(run_info)
        filename = "#{create_full_path}/#{collector_id}-#{VERSION}.ss"
        content = run_info.to_s

        writer.write filename, content
      end

      private

      attr_reader :writer, :path, :collector_id

      #TODO Extract dir creation.
      def create_full_path
        ::FileUtils::mkdir_p path.to_s

        path
      end
    end
  end
end
