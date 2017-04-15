require 'spec_helper'
require 'time'
require 'suspect/gathering/run_info'

RSpec.describe Suspect::Gathering::RunInfo do
  describe '#to_json' do
    let(:data) do
      {'collector_id' => '12345',
       'notified_at' => '2012-03-19T07:22Z',
       'failed_files' => %w(b_spec.rb),
       'modified_files' => %w(a.rb c.rb),
       'commit_hash' => 'fake_hash',
       'patch' => 'fake_patch',
       'version' => '1'}
    end

    it 'serializes all members' do
      run_info = described_class.new(*data.values)

      json = run_info.to_json

      expect(JSON.parse(json)).to eq(data)
    end

    it 'adds version if not provided' do
      run_info = described_class.new

      json = run_info.to_json

      expect(JSON.parse(json)['version']).to eq('1')
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
