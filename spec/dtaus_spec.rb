# encoding: utf-8
require 'spec_helper'
# All Test DTA output strings are validated with sFirm => lokal Sparkassen Software
describe KingDta::Dtaus do

  before :each do
    @dtaus = KingDta::Dtaus.new('LK', Date.today)
    @dtaus_gk = KingDta::Dtaus.new('GK', Date.today)
    @kto1 = test_kto1
    @kto2 = test_kto2
    @dtaus.account = KingDta::Account.new(:bank_account_number => @kto1.bank_account_number, :bank_number => @kto1.bank_number, :owner_name => @kto1.owner_name, :bank_name => @kto1.bank_name)
    @dtaus_gk.account = KingDta::Account.new(:bank_account_number => @kto1.bank_account_number, :bank_number => @kto1.bank_number, :owner_name => @kto1.owner_name, :bank_name => @kto1.bank_name)
    @booking = KingDta::Booking.new(KingDta::Account.new(:bank_account_number => @kto2.bank_account_number, :bank_number => @kto2.bank_number, :owner_name => @kto2.owner_name, :bank_name => @kto2.bank_name), 220.25 )
  end

  it "should not init without values" do
    lambda{ KingDta::Dtaus.new }.should raise_error(ArgumentError)
  end

  it "should init with valid values" do
    lambda{ KingDta::Dtaus.new('LK', Date.today) }.should_not raise_error
  end

  it "should not init with an unknown type" do
    lambda{ KingDta::Dtaus.new('UNKNOWN', "date") }.should raise_error(ArgumentError)
  end

  it "should not init with an invalid date" do
    lambda{ KingDta::Dtaus.new('LK', "date") }.should raise_error(ArgumentError)
  end

  it "should deny invalid accounts" do
    lambda{ @dtaus.account = "account" }.should raise_error(KingDta::Exception)
  end

  it "should not add a booking if closed" do
    @dtaus.add(@booking)
    @dtaus.create
    lambda{ @dtaus.add(@booking) }.should raise_error(KingDta::Exception)
  end

  it "should not add a booking if closed" do
    @dtaus.add(@booking)
    negative_booking = KingDta::Booking.new(KingDta::Account.new(:bank_account_number => @kto2.bank_account_number, :bank_number => @kto2.bank_number, :owner_name => @kto2.owner_name, :bank_name => @kto2.bank_name ), -120.25 )
    lambda{ @dtaus.add(negative_booking) }.should raise_error(KingDta::Exception)
  end

  it "should not create if there are no bookings" do
    lambda{ @dtaus.create}.should raise_error(KingDta::Exception)
  end

  it "should create header" do
    str = @dtaus.add_a
    str.length.should == 128
    out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    78289700370000000000               #{Date.today.strftime("%d%m%Y")}                        1"
    str.should == out
    #60-70 kontonummer mit nullen aufgefüllt - hier nicht da ktnr == 10 stellen
    str[60...70].should == "#{test_kto1.bank_account_number}"
    str.should include(test_kto1.bank_number)
  end

  it "should create checksums" do
    @dtaus.add(@booking)
    @dtaus.set_checksums
    @dtaus.sum_bank_account_numbers.should == 2787777
    @dtaus.sum_bank_numbers.should == 37040044
    @dtaus.sum_values.should == 22025
  end

  it "should create c-sektion with default GK account_key" do
    @booking.account_key = nil
    @dtaus_gk.add(@booking)
    @dtaus_gk.bookings.first.text = 'SalesKing Monatsbeitrag 08/10 Freelancer Version'
    @dtaus_gk.add_c(@booking)
    str = @dtaus_gk.dta_string
    str.length.should == 256
    str.should include("51000")
    out = "0216C00000000370400440002787777000000000000051000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGSALESKING MONATSBEITRAG 08/1  010210 FREELANCER VERSION                                              "
    str.should == out
  end

  it "should create c-sektion with booking text at 19" do
    @dtaus.add(@booking)
    @dtaus.bookings.first.text = 'SalesKing Monatsbeitrag 08/10 Freelancer Version'
    @dtaus.add_c(@booking)
    str = @dtaus.dta_string
    str.length.should == 256
    str.should include(@kto2.owner_name.upcase)
    out = "0216C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGSALESKING MONATSBEITRAG 08/1  010210 FREELANCER VERSION                                              "
    str.should == out
  end

  it "should create c-sektion with long account owner name in extension" do
    @dtaus.account = KingDta::Account.new(:bank_account_number => @kto1.bank_account_number, :bank_number => @kto1.bank_number,
                                          :owner_name =>  'A very long name exeeding 27 characters even longer 54 chars', :bank_name => @kto1.bank_name)

    @dtaus.add(@booking)
    @dtaus.bookings.first.text = 'SalesKing Monatsbeitrag 08/10 Freelancer Version'
    @dtaus.add_c(@booking)
    str = @dtaus.dta_string
    str.length.should == 256
    str.should include(@kto2.owner_name.upcase)
    out = "0245C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                   A VERY LONG NAME EXEEDING 2SALESKING MONATSBEITRAG 08/1  020210 FREELANCER VERSION      037 CHARACTERS EVEN LONGER 54           "
    str.should == out
  end

  it "should create c-sektion with default booking text" do
    @dtaus.default_text = 'Default verwendungszweck'
    @dtaus.add_c(@booking)
    str = @dtaus.dta_string
    str.length.should == 256
    str.should include(@kto2.owner_name.upcase)
    out = "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "
    str.should == out
  end

  it "should create the whole dta string with a single booking" do
    @dtaus.default_text = 'Default verwendungszweck'
    @dtaus.add(@booking)
    str = @dtaus.create
    str.length.should == 512
    str.should include(@kto1.owner_name.upcase)
    str.should include(@kto2.owner_name.upcase)
    str.should include(@dtaus.default_text.upcase)
    out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    78289700370000000000               #{Date.today.strftime("%d%m%Y")}                        1"+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0128E     0000001000000000000000000000002787777000000000370400440000000022025                                                   "
    str.should == out
  end

  it "should create whole dta string with long texts exeeding extension" do
    @dtaus.account = KingDta::Account.new(:bank_account_number => @kto1.bank_account_number, :bank_number => @kto1.bank_number,
                                          :owner_name =>  'A very long name exeeding 27 characters even longer 54 chars', :bank_name => @kto1.bank_name)
    @dtaus.add(@booking)
    @dtaus.bookings.first.text = 'Rgn R-3456-0102220 Monatsbeitrag 08/10 Freelancer Version Vielen Dank Ihre SalesKing GmbH' * 20
    @dtaus.bookings.first.account.owner_name =  'A very long name exeeding 27 characters even longer 54 chars'
    str = @dtaus.create ## should not raise error
  end

  it "should create whole dta string with long booking text in extension" do
    @dtaus.add(@booking)
    @dtaus.bookings.first.text = 'Rgn R-3456-0102220 Monatsbeitrag 08/10 Freelancer Version Vielen Dank Ihre SalesKing GmbH'
    str = @dtaus.create
    str.length.should == 640
    str.should include(@kto2.owner_name.upcase)
    out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    78289700370000000000               #{Date.today.strftime("%d%m%Y")}                        1"+
          "0274C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGRGN R-3456-0102220 MONATSBE1  0302ITRAG 08/10 FREELANCER VERS02ION VIELEN DANK IHRE SALESK           02ING GMBH                                                                                                                      "+
          "0128E     0000001000000000000000000000002787777000000000370400440000000022025                                                   "
    str.should == out
  end

  it "should create the whole dta string with a lot of bookings" do
    @dtaus.default_text = 'Default Verwendungszweck'
    6.times { @dtaus.add(@booking) }
    str = @dtaus.create
    str.length.should == 1792
    str.should include(@kto1.owner_name.upcase)
    str.should include(@kto2.owner_name.upcase)
    str.should include(@dtaus.default_text.upcase)
    out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    78289700370000000000               #{Date.today.strftime("%d%m%Y")}                        1"+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0128E     0000006000000000000000000000016726662000000002222402640000000132150                                                   "
    str.should == out
  end

  it "should create file" do
    @dtaus.default_text = 'Default Verwendungszweck'
    6.times { @dtaus.add(@booking) }
    # create test output file in spec dir
    filename = File.join(File.dirname(__FILE__), 'test_output.dta')
    @dtaus.create_file(filename)
    str = ''
    File.open(filename, 'r').each do |ln|
      str << ln
    end
    str.length.should == 1792
    #remove testfile
    File.delete(filename)
  end

end
