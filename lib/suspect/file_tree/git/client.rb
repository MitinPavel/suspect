module Suspect
  module FileTree
    module Git
      class Client
        def branch
          `git rev-parse --abbrev-ref HEAD`
        end

        def files
          `git ls-files --full-name`
        end

        def modified_files
          `git ls-files --full-name --modified`
        end

        def commit_hash
          `git log -1 --format="%H"`
        end

        def diff
          `git diff`
        end
      end
    end
  end
end
