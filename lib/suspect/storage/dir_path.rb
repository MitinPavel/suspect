module Suspect
  module Storage
      class DirPath
      def initialize(base_path, clock)
        @base_path = base_path
        @clock = clock
      end

      def expand_path
        File.join(base_path,
                  format(clock.year),
                  format(clock.month),
                  format(clock.day))
      end

      def to_s
        expand_path
      end

      private

      attr_reader :base_path, :clock

      def format(number)
        number.to_s.rjust(2, '0')
      end
    end
  end
end
