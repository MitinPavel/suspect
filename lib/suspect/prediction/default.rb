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
          file_helper = ::Suspect::FileUtils::Idempotent.new
          collector_id_generator = ::Suspect::Setup::CollectorIdGenerator.new
          dir_structure = ::Suspect::Setup::DirStructure.new(root_path, collector_id_generator, file_helper).build
          storage_path = dir_structure.storage_path
          file_tree = ::Suspect::FileTree::Git::Snapshot.new
          reader = ::Suspect::Storage::Reader.new(storage_path)

          Naive::AllFound.new(reader, file_tree).paths
        end
      end
    end
  end
end
