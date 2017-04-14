require 'spec_helper'
require 'suspect/setup/collector_id_generator'

RSpec.describe Suspect::Setup::CollectorIdGenerator do
  describe '#next' do
    it 'generates unique values' do
      first_generator = described_class.new
      second_generator = described_class.new

      generated = []
      10.times do
         generated << first_generator.next
         generated << second_generator.next
      end

      expect(generated).to eq(generated.uniq)
    end
  end
end
