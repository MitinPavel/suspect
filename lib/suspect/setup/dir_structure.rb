module Suspect
  module Setup
    class DirStructure
      MAIN_DIR_NAME = 'suspect'
      STORAGE_DIR_NAME = 'storage'
      COLLECTOR_ID_NAME = 'collector_id'

      def initialize(root_path, collector_id_generator, file_helper)
        @root_path = root_path
        @collector_id_generator = collector_id_generator
        @file_helper = file_helper
      end

      def build
        create_dirs
        create_collector_id_file

        self
      end

      def storage_path
        main_dir_path + STORAGE_DIR_NAME
      end

      def collector_id_path
        main_dir_path + COLLECTOR_ID_NAME
      end

      private

      attr_reader :root_path, :collector_id_generator, :file_helper

      def main_dir_path
        root_path + MAIN_DIR_NAME
      end

      def create_collector_id_file
        file_helper.write collector_id_path,
                          collector_id_generator.next
      end

      def create_dirs
        file_helper.mkdir storage_path
      end
    end
  end
end
