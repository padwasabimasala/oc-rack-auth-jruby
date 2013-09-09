require 'spec_helper'

describe Rack::Auth::SmD do

  describe "#initialize" do
    context "defaults" do
      its(:int_range){ should be (2 ** 16) }
      its(:ms_per_unit){ should be Rack::Auth::SmD::MS_PER_HOUR }
    end

    context "with params" do
      it "accepts a range" do
        Rack::Auth::SmD.new({ int_range: (2 ** 32) }).int_range.should eq (2 ** 32)
      end

      it "accepts milliseconds per unit" do
        Rack::Auth::SmD.new({ ms_per_unit: 2000 }).ms_per_unit.should eq (2000)
      end
    end
  end
end