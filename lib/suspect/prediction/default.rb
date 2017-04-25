module Suspect
  module Prediction
    class Default
      class << self
        def paths
          Naive::AllFound.new.paths
        end
      end
    end
  end
end
