# encoding: utf-8
require 'spec_helper'

describe KingDta::Booking do

  before :each do
    @account = KingDta::Account.new(receiver_opts)
  end

  it "should have no rounding error for string" do
    booking = KingDta::Booking.new(@account, "159.73")
    booking.value.should == 15973
  end

  it "should raise if initialized without an account" do
    lambda{ KingDta::Booking.new("account", Date.today) }.should raise_error(KingDta::Exception)
  end

  it "should raise if initialized with wrong value type" do
    lambda{ KingDta::Booking.new(@account, Date.today) }.should raise_error(KingDta::Exception)
  end

  it "should raise if initialized with 0 value" do
    lambda{ KingDta::Booking.new(@account, 0) }.should raise_error(KingDta::Exception)
    lambda{ KingDta::Booking.new(@account, 0.00) }.should raise_error(KingDta::Exception)
  end

  it "should raise if currency size is greater than 3" do
    lambda{ KingDta::Booking.new(@account, 15973, nil, nil, "EURO") }.should raise_error(KingDta::Exception,/currency code needs to be 3 chars. You gave me: .*/)
  end

  it "should raise if currency size is less than 3" do
    lambda{ KingDta::Booking.new(@account, 15973, nil, nil, "EU") }.should raise_error(KingDta::Exception,/currency code needs to be 3 chars. You gave me: .*/)
  end

  it "should set pos to false with negative value" do
    b = KingDta::Booking.new(@account, -1)
    b.value.should == 100
    b.should_not be_pos
  end

  it "should have no rounding error for float" do
    booking = KingDta::Booking.new(@account, 159.73)
    booking.value.should == 15973
  end
end
