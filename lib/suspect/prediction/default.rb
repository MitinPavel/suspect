require 'pathname'

require 'suspect/file_tree/git/snapshot'
require 'suspect/storage/reader'
require 'suspect/prediction/naive/all_found'

module Suspect
  module Prediction
    class Default
      class << self
        def paths
          root_path = ::Pathname.new('.')
          structure = ::Suspect::Setup::Structure.new(root_path)
          storage_path = structure.storage_path
          reader = ::Suspect::Storage::Reader.new(storage_path)
          file_tree = ::Suspect::FileTree::Git::Snapshot.new

          Naive::AllFound.new(reader, file_tree).paths
        end
      end
    end
  end
end
