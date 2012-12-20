# encoding: utf-8
require 'spec_helper'

describe KingDta::DtazvBooking do

  before :each do
    @account = KingDta::Account.new(receiver_opts)
    @text_pass = "A"*140
    @text_fail = "A"*141
    @cust_bill_pass = "A"*27
    @cust_bill_fail = "A"*28
  end

  it "should raise an exception if the text length is greater than 140 chars" do
    dtazv_booking = KingDta::DtazvBooking.new(@account, "9000.1")
    lambda { dtazv_booking.text = @text_fail }.should raise_error(KingDta::Exception)
  end

  it "should raise an exception if the customer bill text length is greater than 27 chars" do
    dtazv_booking = KingDta::DtazvBooking.new(@account, "9000.1")
    lambda { dtazv_booking.customer_bill_text= @cust_bill_fail }.should raise_error(KingDta::Exception)
  end

end
