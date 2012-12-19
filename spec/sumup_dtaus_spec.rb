# encoding: utf-8

require 'spec_helper'

describe KingDta::SumupDtaus do

  before :each do
    @sumup_dtaus = KingDta::SumupDtaus.new('GK')
    @kto1 = test_kto1
    @kto2 = test_kto2
    @sumup_dtaus.account = KingDta::Account.new(:bank_account_number => @kto1.bank_account_number, :bank_number => @kto1.bank_number, :owner_name => @kto1.owner_name, :bank_name => @kto1.bank_name)
    # TODO: Finish writing this test with DtausBooking, need to write tests for that first though.
    @booking = KingDta::DtausBooking.new(KingDta::Account.new(:bank_account_number => @kto2.bank_account_number, :bank_number => @kto2.bank_number, :owner_name => @kto2.owner_name, :bank_name => @kto2.bank_name), 220.25 )
  end

  it "should create a C block that contains 2 booking texts" do
    @sumup_dtaus.add(@booking)
    @sumup_dtaus.bookings.first.text = ['SalesKing Monatsbeitrag ','08/10 Freelancer Version']
    @sumup_dtaus.add_c(@booking)
    str = @sumup_dtaus.dta_string
    str.length.should == 256
    str.should include(@kto2.owner_name.upcase)
    # The first one is the original
    #out = "0216C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGSALESKING MONATSBEITRAG 08/1  010210 FREELANCER VERSION                                              "
    out =  "0216C00000000370400440002787777000000000000051000 0000000000037040044782897003700000022025   PETER & MAY GMBH                   GIMME YOUR MONEY AG        SalesKing Monatsbeitrag    1  010208/10 Freelancer Version                                           "
    str.should == out
  end

  it "should create c-section with default booking text" do
    @sumup_dtaus.default_text = 'Default verwendungszweck'
    @sumup_dtaus.add_c(@booking)
    str = @sumup_dtaus.dta_string
    str.length.should == 256
    str.should include(@kto2.owner_name.upcase)
    out =  "0216C00000000370400440002787777000000000000051000 0000000000037040044782897003700000022025   PETER & MAY GMBH                   GIMME YOUR MONEY AG        DEFAULT VERWENDUNGSZWECK   1  0102                                                                   "
    str.should == out
  end

  it "should create c-sektion with long account owner name in extension" do
    @sumup_dtaus.account = KingDta::Account.new(:bank_account_number => @kto1.bank_account_number, :bank_number => @kto1.bank_number, 
                                          :owner_name =>  'A very long name exeeding 27 characters even longer 54 chars', :bank_name => @kto1.bank_name)

    @sumup_dtaus.add(@booking)
    @sumup_dtaus.bookings.first.text = ['SalesKing Monatsbeitrag ','08/10 Freelancer Version']
    @sumup_dtaus.add_c(@booking)
    str = @sumup_dtaus.dta_string
    str.length.should == 256
    str.should include(@kto2.owner_name.upcase)
    out = "0245C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                   A VERY LONG NAME EXEEDING 2SALESKING MONATSBEITRAG 08/1  020210 FREELANCER VERSION      037 CHARACTERS EVEN LONGER 54           "
    str.should == out
  end

end
