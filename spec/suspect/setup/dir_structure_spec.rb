require 'spec_helper'
require 'suspect/setup/dir_structure'
require 'suspect/setup/collector_id_generator'
require 'suspect/file_utils/idempotent'

RSpec.describe Suspect::Setup::DirStructure do
  let(:file_helper) { instance_double(::Suspect::FileUtils::Idempotent, mkdir: nil, write: nil) }
  let(:random_generator) { instance_double(::Suspect::Setup::CollectorIdGenerator, next: 42) }

  describe '#build' do
    it 'creates suspect/storage directory' do
      expect(file_helper).to receive(:mkdir).with ::Pathname.new('suspect/storage')

      described_class.new(::Pathname.new('.'), random_generator, file_helper).build
    end

    it 'creates collector_id file' do
      allow(random_generator).to receive(:next) { 'abcdef' }
      expect(file_helper).to receive(:write).with ::Pathname.new('suspect/collector_id'), 'abcdef'

      described_class.new(::Pathname.new('.'), random_generator, file_helper).build
    end
  end
end
