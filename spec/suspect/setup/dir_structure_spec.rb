require 'spec_helper'
require 'suspect/setup/dir_structure'
require 'suspect/file_utils/idempotent'

RSpec.describe Suspect::Setup::DirStructure do
  let(:file_helper) { instance_double(::Suspect::FileUtils::Idempotent) }

  describe '#build' do
    it 'creates suspect/storage directory' do
      expect(file_helper).to receive(:mkdir).with ::Pathname.new('.') + 'suspect/storage'

      described_class.new(::Pathname.new('.'), file_helper).build
    end
  end
end
