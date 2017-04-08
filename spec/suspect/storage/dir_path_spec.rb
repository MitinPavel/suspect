require 'spec_helper'
require 'suspect/storage/dir_path'

RSpec.describe Suspect::Storage::DirPath do
  describe '#to_s' do
    let(:clock) { }
    specify { expect(actual('base/path/', '1 Jan 2017')).to  eq('base/path/2017/01/01') }
    specify { expect(actual('base/path/', '31 Dec 2016')).to eq('base/path/2016/12/31') }

    def actual(base_path, date_sting)
      described_class.new(base_path, Date.parse(date_sting)).to_s
    end
  end
end
