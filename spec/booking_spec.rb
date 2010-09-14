require "#{File.dirname(__FILE__)}/spec_helper"

describe KingDta::Booking do

  before :each do
    kto1 = test_kto1
    kto2 = test_kto2
    @account = KingDta::Account.new( kto2.nr, kto2.blz, kto2.name, kto2.bank )
  end

  it "should have no rounding error for string" do
    booking = KingDta::Booking.new(@account, "159.73")
    booking.value.should == 15973
  end

  it "should raise if initialized with wrong value tpye" do
    lambda{ KingDta::Booking.new(@account, Date.today) }.should raise_error
  end

  it "should raise if initialized with 0 value" do
    lambda{ KingDta::Booking.new(@account, 0) }.should raise_error
    lambda{ KingDta::Booking.new(@account, 0.00) }.should raise_error
  end

  it "should set pos to false with negative value" do
    b = KingDta::Booking.new(@account, -1)
    b.value.should == -100
    b.pos?.should be_false
  end
  
  it "should have no rounding error for float" do
    booking = KingDta::Booking.new(@account, 159.73)
    booking.value.should == 15973
  end
end