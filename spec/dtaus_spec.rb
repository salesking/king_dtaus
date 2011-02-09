require "#{File.dirname(__FILE__)}/spec_helper"

# All Test DTA output strings are validated with sFirm => lokal Sparkassen Software
describe KingDta::Dtaus do

  before :each do
    @dtaus = KingDta::Dtaus.new('LK', Date.today)
    @kto1 = test_kto1
    @kto2 = test_kto2
    @dtaus.account = KingDta::Account.new( @kto1.nr, @kto1.blz, @kto1.name, @kto1.bank )
    @booking = KingDta::Booking.new(
                KingDta::Account.new( @kto2.nr, @kto2.blz, @kto2.name, @kto2.bank ),
                220.25 )
  end

  it "should not init without values" do
    lambda{ KingDta::Dtaus.new }.should raise_error(ArgumentError)
  end
  
  it "should init with valid values" do
    lambda{ KingDta::Dtaus.new('LK', Date.today) }.should_not raise_error(ArgumentError)
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

  it "should create header" do
    str = @dtaus.add_a
    str.length.should == 128
    out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    00028800370000000000               #{Date.today.strftime("%d%m%Y")}                        1"
    str.should == out
    #60-70 kontonummer mit nullen aufgefüllt
    str[60...70].should == "000#{test_kto1.nr}"
    str.should include(test_kto1.blz)
  end

  it "should create checksums" do
    @dtaus.add(@booking)
    @dtaus.set_checksums
    @dtaus.sum_bank_account_numbers.should == 2787777
    @dtaus.sum_bank_numbers.should == 37040044
    @dtaus.sum_values.should == 22025
  end

  it "should create c-sektion with booking text at 19" do
    @dtaus.add(@booking)
    @dtaus.bookings.first.text = 'SalesKing Monatsbeitrag 08/10 Freelancer Version'
    @dtaus.add_c(@booking)
    str = @dtaus.dta_string
    str.length.should == 256
    str.should include(@kto2.name.upcase)
    out = "0216C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGSALESKING MONATSBEITRAG 08/1  010210 FREELANCER VERSION                                              "
    str.should == out
  end

  it "should create c-sektion with default booking text" do
    @dtaus.default_text = 'Default verwendungszweck'
    @dtaus.add_c(@booking)
    str = @dtaus.dta_string
    str.length.should == 256
    str.should include(@kto2.name.upcase)
    out = "0187C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "
    str.should == out
  end

  it "should create the whole dta string with a single booking" do
    @dtaus.default_text = 'Default verwendungszweck'
    @dtaus.add(@booking)
    str = @dtaus.create
    str.length.should == 512
    str.should include(@kto1.name.upcase)
    str.should include(@kto2.name.upcase)
    str.should include(@dtaus.default_text.upcase)
    out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    00028800370000000000               #{Date.today.strftime("%d%m%Y")}                        1"+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0128E     0000001000000000000000000000002787777000000000370400440000000022025                                                   "
    str.should == out
  end

  it "should create whole dta string with long booking text in extension" do
    @dtaus.add(@booking)
    @dtaus.bookings.first.text = 'Rgn R-3456-0102220 Monatsbeitrag 08/10 Freelancer Version Vielen Dank Ihre SalesKing GmbH'
    str = @dtaus.create
    str.length.should == 640
    str.should include(@kto2.name.upcase)
    out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    00028800370000000000               #{Date.today.strftime("%d%m%Y")}                        1"+
          "0274C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGRGN R-3456-0102220 MONATSBE1  0302ITRAG 08/10 FREELANCER VERS02ION VIELEN DANK IHRE SALESK           02ING GMBH                                                                                                                      "+
          "0128E     0000001000000000000000000000002787777000000000370400440000000022025                                                   "
    str.should == out
  end

  it "should create the whole dta string with a lot of bookings" do
    @dtaus.default_text = 'Default Verwendungszweck'
    6.times { @dtaus.add(@booking) }
    str = @dtaus.create
    str.length.should == 1792
    str.should include(@kto1.name.upcase)
    str.should include(@kto2.name.upcase)
    str.should include(@dtaus.default_text.upcase)
    out = "0128ALK3704004400000000GIMME YOUR MONEY AG        #{Date.today.strftime("%d%m%y")}    00028800370000000000               #{Date.today.strftime("%d%m%Y")}                        1"+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0187C00000000370400440002787777000000000000005000 0000000000037040044000288003700000022025   PETER & MAY GMBH                           GIMME YOUR MONEY AGDEFAULT VERWENDUNGSZWECK   1  00                                                                     "+
          "0128E     0000006000000000000000000000016726662000000002222402640000000132150                                                   "
    str.should == out
  end

  xit "should create file" do
    @dtaus.default_text = 'Default Verwendungszweck'
    6.times { @dtaus.add(@booking) }
    file = @dtaus.create_file
  end

end
