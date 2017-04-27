module Suspect
  module Setup
    class Structure
      MAIN_DIR_NAME = 'suspect'
      STORAGE_DIR_NAME = 'storage'
      COLLECTOR_ID_NAME = 'collector_id'

      def initialize(root_path)
        @root_path = root_path
      end

      def storage_path
        main_dir_path + STORAGE_DIR_NAME
      end

      def collector_id_path
        main_dir_path + COLLECTOR_ID_NAME
      end

      private

      attr_reader :root_path

      def main_dir_path
        root_path + MAIN_DIR_NAME
      end
    end
  end
end
