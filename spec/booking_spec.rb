require 'spec/spec_helper'

describe KingDta::Booking do

  before :each do
    kto1 = test_kto1
    kto2 = test_kto2
    @account = KingDta::Account.new(:account_number => kto2.account_number, :bank_number => kto2.bank_number, :client_name => kto2.client_name, :bank_name => kto2.bank_name )
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