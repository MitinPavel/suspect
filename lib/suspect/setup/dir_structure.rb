module Suspect
  module Setup
    class DirStructure
      MAIN_DIR_NAME = 'suspect'
      STORAGE_DIR_NAME = 'storage'

      def initialize(root_path, file_helper)
        @root_path = root_path
        @file_helper = file_helper
      end

      def build
        file_helper.mkdir root_path + MAIN_DIR_NAME + STORAGE_DIR_NAME
      end

      private

      attr_reader :root_path, :file_helper
    end
  end
end
