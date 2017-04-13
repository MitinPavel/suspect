require 'fileutils'

module Suspect
  module FileUtils
    ##
    # A humble object class for file system manipulations
    #
    class Idempotent
      def mkdir(path)
        ::FileUtils::mkdir_p path
      end
    end
  end
end
