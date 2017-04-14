require 'securerandom'

module Suspect
  module Setup
    class CollectorIdGenerator
      def next
        ::SecureRandom.hex(4)
      end
    end
  end
end
