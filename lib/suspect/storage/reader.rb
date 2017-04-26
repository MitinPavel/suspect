require 'suspect/gathering/run_info'

module Suspect
  module Storage
    class Reader
      def initialize(base_path)
        @base_path = base_path
      end

      def foreach
        paths.each do |path|
          File.open(path).each do |line|
            yield run_info_from(line)
          end
        end
      end

      private

      attr_reader :base_path

      def paths
        Dir.glob("#{base_path}/**/*.ss")
      end

      def run_info_from(line)
        data = JSON.parse(line)
        run_info = ::Suspect::Gathering::RunInfo.new

        data.each_key do |k|
          run_info.public_send "#{k}=", data[k]
        end

        run_info
      end
    end
  end
end
