require 'spec_helper'
require 'suspect/prediction/default'
require 'suspect/prediction/naive/all_found'

RSpec.describe Suspect::Prediction::Default do
  describe '#path' do
    before do
      allow_any_instance_of(::Suspect::Setup::DirStructure).to receive(:build).and_return OpenStruct.new(storage_path: '.')
    end

    it 'delegates to the default strategy' do
      allow_any_instance_of(::Suspect::Prediction::Naive::AllFound).to receive(:paths).and_return %w(./path/to/a_spec.rb)

      expect(described_class.paths).to eq(%w(./path/to/a_spec.rb))
    end
  end
end
