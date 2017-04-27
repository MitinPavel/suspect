module Suspect
  module Setup
    class Creator
      def initialize(structure, collector_id_generator, file_helper)
        @structure = structure
        @collector_id_generator = collector_id_generator
        @file_helper = file_helper
      end

      def build
        create_storage_dir
        create_collector_id_file
      end

      private

      attr_reader :structure, :collector_id_generator, :file_helper

      def create_collector_id_file
        file_helper.write structure.collector_id_path,
                          collector_id_generator.next
      end

      def create_storage_dir
        file_helper.mkdir structure.storage_path
      end
    end
  end
end
