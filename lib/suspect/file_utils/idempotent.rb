require 'fileutils'
require 'tempfile'

module Suspect
  module FileUtils
    ##
    # A humble object class for file system manipulations
    #
    class Idempotent
      def mkdir(path)
        ::FileUtils::mkdir_p path
      end

      def write(path, content)
        return if path.exist?

        temp_file = ::Tempfile.new
        temp_file.write content
        temp_file.close

        # FileUtils.mv doesn't support --no-clobber option.
        `mv --no-clobber #{temp_file.path} #{path.expand_path}`
      end

      def read(path)
        ::File.open(path) { |f| f.readline }
      end
    end
  end
end
