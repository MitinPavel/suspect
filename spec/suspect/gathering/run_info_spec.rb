require 'spec_helper'
require 'suspect/gathering/run_info'

RSpec.describe Suspect::Gathering::RunInfo do
  describe '#initialize' do
    it 'fills in VERSION if not provided' do
      run_info = described_class.new
      expect(run_info.version).to eq('1')
      expect(described_class::VERSION).to eq('1')
    end
  end

  describe 'to_h' do
    it 'includes all members' do
      run_info = described_class.new('fake_collector_id',
                                     '2012-03-19T07:22Z',
                                     4,
                                     3,
                                     2,
                                     %w(b_spec.rb),
                                     %w(a.rb c.rb),
                                     'master',
                                     'fake_hash',
                                     'fake_patch',
                                     '1')

      expect(run_info.to_h).to eq(collector_id: 'fake_collector_id',
                                  notified_at: '2012-03-19T07:22Z',
                                  failed_example_count: 4,
                                  successful_example_count: 3,
                                  pending_example_count: 2,
                                  failed_files: %w(b_spec.rb),
                                  modified_files: %w(a.rb c.rb),
                                  branch: 'master',
                                  commit_hash: 'fake_hash',
                                  patch: 'fake_patch',
                                  version: '1')
    end
  end
end
