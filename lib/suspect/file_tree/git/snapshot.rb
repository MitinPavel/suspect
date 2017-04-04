require_relative './client'

module Suspect
  module FileTree
    module Git
      class Snapshot
        def initialize(client = ::Suspect::FileTree::Git::Client.new)
          @client = client
        end

        def modified_files
          client.modified_files.
              split(/\n/).
              map { |path| "/#{path}"}
        end

        def commit_hash
          client.commit_hash.sub(/\n\z/, '')
        end

        private

        attr_reader :client
      end
    end
  end
end
