require 'fileutils'

require_relative 'flock_writer'
require_relative 'dir_path'

module Suspect
  module Storage
    class Appender
      VERSION = '1'

      def initialize(opts)
        @writer = opts[:writer] || FlockWriter.new
        @path = opts[:path] || fail(ArgumentError, 'No path found')
        @actor_id = opts[:actor_id] || fail(ArgumentError, 'No actor_id found')
      end

      def append(run_info)
        filename = "#{create_full_path}/#{actor_id}-#{VERSION}.ss"
        content = run_info.to_s

        writer.write filename, content
      end

      private

      attr_reader :writer, :path, :actor_id

      #TODO Extract dir creation.
      def create_full_path
        FileUtils::mkdir_p path.to_s

        path
      end
    end
  end
end
