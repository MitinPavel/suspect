require 'spec_helper'
require 'suspect/setup/structure'
require 'suspect/setup/creator'
require 'suspect/setup/collector_id_generator'
require 'suspect/file_utils/idempotent'

RSpec.describe Suspect::Setup::Creator do
  let(:structure) { ::Suspect::Setup::Structure.new(::Pathname.new('.')) }
  let(:file_helper) { instance_double(::Suspect::FileUtils::Idempotent, mkdir: nil, write: nil) }
  let(:random_generator) { instance_double(::Suspect::Setup::CollectorIdGenerator, next: 42) }

  describe '#build' do
    it 'creates storage directory' do
      allow(structure).to receive(:storage_path) { ::Pathname.new('suspect/storage') }
      expect(file_helper).to receive(:mkdir).with ::Pathname.new('suspect/storage')

      described_class.new(structure, random_generator, file_helper).build
    end

    it 'creates collector_id file' do
      allow(random_generator).to receive(:next) { 'abcdef' }
      allow(structure).to receive(:collector_id_path) { ::Pathname.new('suspect/collector_id') }
      expect(file_helper).to receive(:write).with ::Pathname.new('suspect/collector_id'), 'abcdef'

      described_class.new(structure, random_generator, file_helper).build
    end
  end
end
