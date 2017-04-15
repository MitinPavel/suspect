require 'spec_helper'
require 'suspect/gathering/run_info'

RSpec.describe Suspect::Gathering::RunInfo do
  describe '#to_json' do
    it 'serializes all members' do
      data = {'failed_files' => %w(b_spec.rb),
              'modified_files' => %w(a.rb c.rb),
              'commit_hash' => 'fake_hash'}
      run_info = described_class.new(*data.values)

      json = run_info.to_json

      expect(JSON.parse(json)).to eq(data)
    end
  end

  describe '#to_s' do
    it 'delegates to #to_json' do
      run_info = described_class.new
      allow(run_info).to receive(:to_json) { 'I am JSON' }

      expect(run_info.to_s).to eq('I am JSON')
    end
  end
end
