require 'spec_helper'
require 'suspect/setup/structure'

RSpec.describe Suspect::Setup::Structure do
  describe '#storage_path' do
    subject {described_class.new(::Pathname.new('.')).storage_path}
    it {is_expected.to eq(::Pathname.new('suspect/storage'))}
  end

  describe '#collector_id_path' do
    subject {described_class.new(::Pathname.new('.')).collector_id_path}
    it {is_expected.to eq(::Pathname.new('suspect/collector_id'))}
  end
end
