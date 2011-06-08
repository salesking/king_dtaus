require 'spec/spec_helper'
# All Test DTAZV output strings are validated with sFirm => lokal Sparkassen Software
describe KingDta::Dtazv do

  before :each do
    @dtazv = KingDta::Dtazv.new(Date.today)
    @kto1 = test_kto1
    @kto2 = test_kto2
    @dtazv.account = KingDta::Account.new( @kto1.account_number, @kto1.bank_number, @kto1.client_name, @kto1.bank_name )
    @booking = KingDta::Booking.new(KingDta::Account.new( @kto2.account_number, @kto2.bank_number, @kto2.client_name, @kto2.bank_name ), 220.25 )
  end

  it "should init without values" do
    lambda{ KingDta::Dtazv.new }.should_not raise_error(ArgumentError)
  end

  it "should init with valid values" do
    lambda{ KingDta::Dtazv.new(Date.today) }.should_not raise_error(ArgumentError)
  end

  # Deprecated
  # it "should not init with an unknown type" do
  #   lambda{ KingDta::Dtaus.new('UNKNOWN', "date") }.should raise_error(ArgumentError)
  # end

  it "should not init with an invalid date" do
    lambda{ KingDta::Dtazv.new("date") }.should raise_error(ArgumentError)
  end

  it "should deny invalid accounts" do
    lambda{ @dtazv.account = "account" }.should raise_error(KingDta::Exception)
  end

  # TODO
  # it "should not add a booking if closed" do
  #   @dtaus.add(@booking)
  #   @dtaus.create
  #   lambda{ @dtaus.add(@booking) }.should raise_error(KingDta::Exception)
  # end

  # TODO
  # it "should not add a booking if closed" do
  #   @dtaus.add(@booking)
  #   negative_booking = KingDta::Booking.new(KingDta::Account.new( @kto2.nr, @kto2.blz, @kto2.name, @kto2.bank ), -120.25 )
  #   lambda{ @dtaus.add(negative_booking) }.should raise_error(KingDta::Exception)
  # end

  # TODO
  # it "should not create if there are no bookings" do
  #   lambda{ @dtaus.create}.should raise_error(KingDta::Exception)
  # end

  # TODO
  # it "should create header" do
  #   str = @dtaus.add_a
  #   str.length.should == 128
  #   out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    78289700370000000000               #{Date.today.strftime("%d%m%Y")}                        1"
  #   str.should == out
  #   #60-70 kontonummer mit nullen aufgefüllt - hier nicht da ktnr == 10 stellen
  #   str[60...70].should == "#{test_kto1.nr}"
  #   str.should include(test_kto1.blz)
  # end

  # TODO
  # it "should create checksums" do
  #   @dtaus.add(@booking)
  #   @dtaus.set_checksums
  #   @dtaus.sum_bank_account_numbers.should == 2787777
  #   @dtaus.sum_bank_numbers.should == 37040044
  #   @dtaus.sum_values.should == 22025
  # end

  # TODO
  # it "should create c-sektion with booking text at 19" do
  #   @dtaus.add(@booking)
  #   @dtaus.bookings.first.text = 'SalesKing Monatsbeitrag 08/10 Freelancer Version'
  #   @dtaus.add_c(@booking)
  #   str = @dtaus.dta_string
  #   str.length.should == 256
  #   str.should include(@kto2.name.upcase)
  #   out = "0216C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGSALESKING MONATSBEITRAG 08/1  010210 FREELANCER VERSION                                              "
  #   str.should == out
  # end

  # TODO
  # it "should create c-sektion with default booking text" do
  #   @dtaus.default_text = 'Default verwendungszweck'
  #   @dtaus.add_c(@booking)
  #   str = @dtaus.dta_string
  #   str.length.should == 256
  #   str.should include(@kto2.name.upcase)
  #   out = "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "
  #   str.should == out
  # end

  # TODO
  # it "should create the whole dta string with a single booking" do
  #   @dtaus.default_text = 'Default verwendungszweck'
  #   @dtaus.add(@booking)
  #   str = @dtaus.create
  #   str.length.should == 512
  #   str.should include(@kto1.name.upcase)
  #   str.should include(@kto2.name.upcase)
  #   str.should include(@dtaus.default_text.upcase)
  #   out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    78289700370000000000               #{Date.today.strftime("%d%m%Y")}                        1"+
  #         "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
  #         "0128E     0000001000000000000000000000002787777000000000370400440000000022025                                                   "
  #   str.should == out
  # end

  # TODO
  # it "should create whole dta string with long booking text in extension" do
  #   @dtaus.add(@booking)
  #   @dtaus.bookings.first.text = 'Rgn R-3456-0102220 Monatsbeitrag 08/10 Freelancer Version Vielen Dank Ihre SalesKing GmbH'
  #   str = @dtaus.create
  #   str.length.should == 640
  #   str.should include(@kto2.name.upcase)
  #   out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    78289700370000000000               #{Date.today.strftime("%d%m%Y")}                        1"+
  #         "0274C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGRGN R-3456-0102220 MONATSBE1  0302ITRAG 08/10 FREELANCER VERS02ION VIELEN DANK IHRE SALESK           02ING GMBH                                                                                                                      "+
  #         "0128E     0000001000000000000000000000002787777000000000370400440000000022025                                                   "
  #   str.should == out
  # end

  # TODO
  # it "should create the whole dta string with a lot of bookings" do
  #   @dtaus.default_text = 'Default Verwendungszweck'
  #   6.times { @dtaus.add(@booking) }
  #   str = @dtaus.create
  #   str.length.should == 1792
  #   str.should include(@kto1.name.upcase)
  #   str.should include(@kto2.name.upcase)
  #   str.should include(@dtaus.default_text.upcase)
  #   out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    78289700370000000000               #{Date.today.strftime("%d%m%Y")}                        1"+
  #         "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
  #         "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
  #         "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
  #         "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
  #         "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
  #         "0187C00000000370400440002787777000000000000005000 0000000000037040044782897003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
  #         "0128E     0000006000000000000000000000016726662000000002222402640000000132150                                                   "
  #   str.should == out
  # end

  # TODO
  # it "should create file" do
  #   @dtaus.default_text = 'Default Verwendungszweck'
  #   6.times { @dtaus.add(@booking) }
  #   # create test output file in spec dir
  #   filename = File.join(File.dirname(__FILE__), 'test_output.dta')
  #   @dtaus.create_file(filename)
  #   str = ''
  #   File.open(filename, 'r').each do |ln|
  #     str << ln
  #   end
  #   str.length.should == 1792
  #   #remove testfile
  #   File.delete(filename)
  # end

end
