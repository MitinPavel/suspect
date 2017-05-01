require 'suspect/gathering/run_info'

module Suspect
  module Storage
    class Reader
      def initialize(base_path, file_helper)
        @base_path = base_path
        @file_helper = file_helper
      end

      def foreach
        run_info_paths.each do |path|
          file_helper.read(path) do |line|
            yield run_info_from(line)
          end
        end
      end

      private

      attr_reader :base_path, :file_helper

      def run_info_paths
        file_helper.file_paths(base_path).select { |p| p.end_with?('.ss') }
      end

      def run_info_from(line)
        data = ::JSON.parse(line)
        run_info = ::Suspect::Gathering::RunInfo.new

        data.each_key do |k|
          run_info.public_send "#{k}=", data[k]
        end

        run_info
      end
    end
  end
end
