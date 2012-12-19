# encoding: utf-8
 
require 'spec_helper'

describe KingDta::DtausBooking do
  
  before :each do
    @account = KingDta::Account.new(receiver_opts)
    @text_pass = ["PASS TEXT AAA", "PASS TEXT BBB"]
    @text_fails = ["A"*28, "B"*28]
  end

  it "should raise an exception if the text parameter is not an array when assigning text" do
    dtaus_booking = KingDta::DtausBooking.new(@account, "9000.1", @text_pass)
    lambda { dtaus_booking.text = "asda" }.should raise_error(KingDta::Exception)
  end

  it "should raise an exception if one or both of the strings in the text array are too long when assigning to text" do
    dtaus_booking =  KingDta::DtausBooking.new(@account, "9000.1", @text_pass) 
    lambda { dtaus_booking.text = @text_fails }.should raise_error(KingDta::Exception)
  end

end
