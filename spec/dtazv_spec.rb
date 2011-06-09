require 'spec/spec_helper'

# All Test DTAZV output strings are validated with sFirm => lokal Sparkassen Software

describe KingDta::Dtazv do

  before :each do
    @dtazv = KingDta::Dtazv.new(Date.today)
    @dudes_konto = dudes_konto
    @fidel_castros_account = fidel_castros_account

    @dtazv.account = KingDta::Account.new(
      @dudes_konto.account_number,
      @dudes_konto.bank_number,
      @dudes_konto.client_name,
      @dudes_konto.client_number,
      @dudes_konto.account_street,
      @dudes_konto.account_city,
      @dudes_konto.account_zip_code,
      @dudes_konto.bank_name,
      @dudes_konto.client_street,
      @dudes_konto.client_city,
      @dudes_konto.client_zip_code,
      @dudes_konto.bank_country_code,
      @dudes_konto.client_country_code
    )

    @fidel_castros_booking = KingDta::Booking.new(KingDta::Account.new(
      @fidel_castros_account.account_number,
      @fidel_castros_account.bank_number,
      @fidel_castros_account.client_name,
      @fidel_castros_account.bank_name,
      @fidel_castros_account.account_street,
      @fidel_castros_account.account_city,
      @fidel_castros_account.account_zip_code,
      @fidel_castros_account.bank_name,
      @fidel_castros_account.client_street,
      @fidel_castros_account.client_city,
      @fidel_castros_account.client_zip_code,
      @fidel_castros_account.bank_country_code,
      @fidel_castros_account.client_country_code
    ), 220.25)

  end

  it "should init without values" do
    lambda{ KingDta::Dtazv.new }.should_not raise_error(ArgumentError)
  end

  it "should init with valid values" do
    lambda{ KingDta::Dtazv.new(Date.today) }.should_not raise_error(ArgumentError)
  end

  it "should not init with an invalid date" do
    lambda{ KingDta::Dtazv.new("date") }.should raise_error(ArgumentError)
  end

  it "should deny invalid accounts" do
    lambda{ @dtazv.account = "account" }.should raise_error(KingDta::Exception)
  end

  # TODO
  it "should create file" do
    @dtazv.default_text = 'Default Verwendungszweck'
    6.times { @dtazv.add(@fidel_castros_booking) }
    # create test output file in spec dir
    filename = File.join(File.dirname(__FILE__), 'test_output.dta')
    @dtazv.create_file(filename)
    str = ''
    File.open(filename, 'r').each do |ln|
      str << ln
    end
    str.length.should == 5120
    #remove testfile
    File.delete(filename)
  end

  it "should not add a booking if closed" do
    @dtazv.add(@fidel_castros_booking)
    @dtazv.create
    lambda{ @dtazv.add(@fidel_castros_booking) }.should raise_error(KingDta::Exception)
  end

  it "should not add a booking if closed" do
    @dtazv.add(@fidel_castros_booking)
    negative_booking = KingDta::Booking.new(KingDta::Account.new(
      @fidel_castros_account.account_number,
      @fidel_castros_account.bank_number,
      @fidel_castros_account.client_name,
      @fidel_castros_account.bank_name,
      @fidel_castros_account.account_street,
      @fidel_castros_account.account_city,
      @fidel_castros_account.account_zip_code,
      @fidel_castros_account.bank_name,
      @fidel_castros_account.client_street,
      @fidel_castros_account.client_city,
      @fidel_castros_account.client_zip_code,
      @fidel_castros_account.bank_country_code,
      @fidel_castros_account.client_country_code
    ), -220.25)
    lambda{ @dtazv.add(negative_booking) }.should raise_error(KingDta::Exception)
  end

  it "should not create if there are no bookings" do
    lambda{ @dtazv.create}.should raise_error(KingDta::Exception)
  end

  # TODO
  # it "should create checksums" do
  #   @dtaus.add(@booking)
  #   @dtaus.set_checksums
  #   @dtaus.sum_bank_account_numbers.should == 2787777
  #   @dtaus.sum_bank_numbers.should == 37040044
  #   @dtaus.sum_values.should == 22025
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


  # Deprecated
  # it "should not init with an unknown type" do
  #   lambda{ KingDta::Dtaus.new('UNKNOWN', "date") }.should raise_error(ArgumentError)
  # end
end
