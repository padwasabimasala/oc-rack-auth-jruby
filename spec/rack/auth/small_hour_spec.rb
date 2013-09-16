require 'spec_helper'

describe Rack::Auth::SmallHour do

  let(:test_time){ Time.utc(2012, 9, 16, 15, 4, 25) }
  let(:rounded_test_time){ Time.utc(2012, 9, 16, 15, 0, 0) }

  before :each do
    Time.stub(:now).and_return(test_time)
  end

  context "constants" do
    it "should have EPOCH_YEAR defined" do
      Rack::Auth::SmallHour::EPOCH_YEAR.should eq 1970
    end

    it "should have YEAR_MASK defined" do
      Rack::Auth::SmallHour::YEAR_MASK.should eq 0b111111111100000000000000
    end

    it "should have YEAR_SHIFT defined" do
      Rack::Auth::SmallHour::YEAR_SHIFT.should eq 14
    end

    it "should have MONTH_MASK defined" do
      Rack::Auth::SmallHour::MONTH_MASK.should eq 0b000000000011110000000000
    end

    it "should have MONTH_SHIFT defined" do
      Rack::Auth::SmallHour::MONTH_SHIFT.should eq 10
    end

    it "should have DAY_MASK defined" do
      Rack::Auth::SmallHour::DAY_MASK.should eq 0b000000000000001111100000
    end

    it "should have DAY_SHIFT defined" do
      Rack::Auth::SmallHour::DAY_SHIFT.should eq 5
    end

    it "should have HOUR_MASK defined" do
      Rack::Auth::SmallHour::HOUR_MASK.should eq 0b000000000000000000011111
    end

    it "should have HOUR_SHIFT defined" do
      Rack::Auth::SmallHour::HOUR_SHIFT.should eq 0
    end
  end

  describe '#initialize' do
    context 'defaults' do
      its(:year){ should eq test_time.year }
      its(:month){ should eq test_time.month }
      its(:day){ should eq test_time.day }
      its(:hour){ should eq test_time.hour }
    end

    context 'with Time parameter' do
      let(:test_time){ Time.utc(2013, 3, 3, 3, 6, 12) }
      subject{ Rack::Auth::SmallHour.new test_time }

      its(:year){ should eq test_time.year }
      its(:month){ should eq test_time.month }
      its(:day){ should eq test_time.day }
      its(:hour){ should eq test_time.hour }
    end
  end

  describe '#year' do
    its(:year){ should eq test_time.year }
  end

  describe '#month' do
    its(:month){ should eq test_time.month }
  end

  describe '#day' do
    its(:day){ should eq test_time.day }
  end

  describe '#hour' do
    its(:hour){ should eq test_time.hour }
  end

  describe '#to_time' do
    its(:to_time){ should eq rounded_test_time }
  end
end