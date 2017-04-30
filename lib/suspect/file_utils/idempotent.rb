require 'fileutils'
require 'tempfile'
require 'find'

module Suspect
  module FileUtils
    ##
    # A humble object class for file system manipulations
    #
    class Idempotent
      def file_paths(base_path)
        result = []

        Find.find(base_path) do |path|
          unless FileTest.directory?(path)
            result << path
          end
        end

        result
      end

      def read(path, &block)
        if block_given?
          ::File.open(path).each &block
        else
          ::File.open(path) { |f| f.readline }
        end
      end

      def write(path, content)
        return if path.exist?

        temp_file = ::Tempfile.new
        temp_file.write content
        temp_file.close

        # FileUtils.mv doesn't support --no-clobber option.
        `mv --no-clobber #{temp_file.path} #{path.expand_path}`
      end

      def mkdir(path)
        ::FileUtils::mkdir_p path
      end
    end
  end
end
