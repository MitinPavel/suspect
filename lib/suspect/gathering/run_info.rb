module Suspect
  module Gathering
    ##
    # Contains results of a spec run.
    #
    RunInfo = Struct.new(:failed_files, # An array of files contained failed examples.
                         :commit_hash) # A hash of the current Git commit.
  end
end
