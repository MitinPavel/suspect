module Suspect
  module Gathering
    ##
    # Contains results of a spec run.
    #
    class RunInfo < Struct.new(:collector_id,
                               :notified_at, # String representation in ISO 8601 format.

                               :failed_example_count,
                               :successful_example_count,
                               :pending_example_count,

                               :failed_files, # An array of files contained failed test examples.
                               :modified_files, # An array of modified files.

                               :branch, # The current Git branch.
                               :commit_hash, # A hash of the current Git commit.
                               :patch, # A version control system patch for the current file tree state.
                               :version) # Should be changed each time
                                         # backward compatibility with already stored data
                                         # is broken.
                                         # Is intended to use during deserialization.

      VERSION = '1'

      def initialize(*params)
        super(*params)
        self.version ||= VERSION
      end
    end
  end
end
