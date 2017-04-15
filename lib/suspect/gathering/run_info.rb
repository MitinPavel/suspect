require 'json'

module Suspect
  module Gathering
    ##
    # Contains results of a spec run.
    #
    class RunInfo < Struct.new(:failed_files, # An array of files contained failed examples.
                               :modified_files, # An array of modified files.
                               :commit_hash) # A hash of the current Git commit.
      def to_json
        JSON.generate(to_h)
      end

      def to_s
        to_json
      end
    end
  end
end
