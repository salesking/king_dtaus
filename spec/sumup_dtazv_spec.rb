# encoding: utf-8

require 'spec_helper'

describe KingDta::SumupDtazv do

  before :each do
    @sumup_dtazv = KingDta::SumupDtazv.new('EUR', Date.parse('2011-08-28'))
    @sumup_dtazv.account = KingDta::Account.new sender_opts
    @booking = KingDta::DtazvBooking.new( KingDta::Account.new( receiver_opts ), 220.25)
  end

  it "should return the proper length of T segment" do
    @sumup_dtazv.add_t(@booking).size.should == 768
  end

  it "should create a T-block with customer bill text in it" do
    @booking.customer_bill_text = "A"*27
    @sumup_dtazv.add_t(@booking)
    str = @sumup_dtazv.dta_string
    out = "0768T37050299EUR132604963411082800000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250                                                                                                                                            00000000                         0013AAAAAAAAAAAAAAAAAAAAAAAAAAA                                   0                                                   00"
    str.should == out
  end

  it "should raise an error if the currency code is greater than three chatacters long" do
    lambda { KingDta::SumupDtazv.new('EURX') }.should raise_error(Exception)
  end

  it "should assign the payment type of 13 for euro transactions" do
    sumup_dtazv = KingDta::SumupDtazv.new('EUR')
    sumup_dtazv.payment_type.should == 13
  end

  it "should assign the payment type of 00 for euro transactions" do
      sumup_dtazv = KingDta::SumupDtazv.new('GBP')
      sumup_dtazv.payment_type.should == 00
  end

  it "should not allow assignment to payment_type instance variable directly" do
      sumup_dtazv = KingDta::SumupDtazv.new('GBP')
      lambda { sumup_dtazv.payment_type = 19 }.should raise_error(NoMethodError)
  end
end
