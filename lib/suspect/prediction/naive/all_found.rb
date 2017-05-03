module Suspect
  module Prediction
    module Naive
      class AllFound
        def initialize(run_infos, file_tree)
          @run_infos = run_infos
          @file_tree = file_tree
        end

        def paths
          result = []
          return result if modified_files.empty?

          run_infos.foreach do |run_info|
            if match?(modified_files, run_info.modified_files)
              result.push *run_info.failed_files
            end
          end

          select_existing_files(result.uniq)
        end

        def match?(first_array, second_array)
          (first_array & second_array).any?
        end

        private

        attr_reader :run_infos, :file_tree

        def modified_files
          @modified_files ||= file_tree.modified_files
        end

        def select_existing_files(files)
          files & file_tree.files
        end
      end
    end
  end
end
