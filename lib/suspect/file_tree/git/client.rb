module Suspect
  module FileTree
    module Git
      class Client
        def modified_files
          `git ls-files --modified`
        end

        def commit_hash
          `git log -1 --format="%H"`
        end
      end
    end
  end
end
