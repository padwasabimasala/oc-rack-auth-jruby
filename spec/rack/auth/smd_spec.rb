require 'spec_helper'

describe Rack::Auth::SmD do

  describe "#initialize" do
    context "defaults" do
      its(:range){ should be Rack::Auth::SmD::DEFAULT_RANGE }
      its(:ms_per_unit){ should be Rack::Auth::SmD::MS_PER_HOUR }
    end

    context "with params" do
      it "accepts a range" do
        Rack::Auth::SmD.new({ range: (2 ** 32) }).range.should eq (2 ** 32)
      end

      it "accepts milliseconds per unit" do
        Rack::Auth::SmD.new({ ms_per_unit: 2000 }).ms_per_unit.should eq (2000)
      end
    end
  end

  describe "#range_in_ms" do
    its(:range_in_ms){ should be_kind_of Integer }
    its(:range_in_ms){ should eq (subject.range * subject.ms_per_unit) }
  end
end