require_relative './client'

module Suspect
  module FileTree
    module Git
      class Snapshot
        def initialize(client = ::Suspect::FileTree::Git::Client.new)
          @client = client
        end

        def branch
          without_new_line(client.branch)
        end

        def modified_files
          client.modified_files.
              split(/\n/).
              map { |path| "/#{path}"}
        end

        def commit_hash
          without_new_line(client.commit_hash)
        end

        def patch
          client.diff
        end

        private

        attr_reader :client

        def without_new_line(str)
          str.sub(/\n\z/, '')
        end
      end
    end
  end
end
