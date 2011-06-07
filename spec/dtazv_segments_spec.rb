require 'spec/spec_helper'
# All Test DTAZV output strings are validated with sFirm => lokal Sparkassen Software
describe KingDta::DtazvSegments do

  before :each do
    @date = Date.today
    @dudes_dtazv_export = KingDta::Dtazv.new(@date)
    @dudes_konto = dudes_konto
    @dudes_dtazv_export.account = KingDta::Account.new(
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
                        @dudes_konto.client_zip_code
                      )
    # @fidel_castros_booking = KingDta::Booking.new(...)
  end

  it "should return the proper P segment" do
    @dudes_dtazv_export.add_p.should == "0256P37040044                                                     Commerzbank K\303\266ln                   5th avenue 55323                        los angeles#{@date.strftime("%y%m%d")}0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
  end

  it "should return the proper length of P segment" do
    @dudes_dtazv_export.add_p.size.should == 256
  end

  it "should return the proper Q segment" do
    @dudes_dtazv_export.add_q.should == "0256Q370400447828970037                                                   GIMME YOUR MONEY AG                  6th avenue 445555                        los angeles#{@date.strftime("%y%m%d")}01#{@date.strftime("%y%m%d")}N 03704004400000000000000000000000000000000000000000000000000000000000000000000"
  end

  it "should return the proper length of P segment" do
    @dudes_dtazv_export.add_q.size.should == 256
  end

  it "should return the proper T segment" do
    # @dudes_dtazv_export.add_t(booking).should == "............"
  end

  it "should return the proper length of T segment" do
    # @dudes_dtazv_export.add_t(booking).size.should == 572
  end

  it "should return the proper V segment" do
    # @dudes_dtazv_export.add_t.should == "..........."
  end

  it "should return the proper length of V segment" do
    # @dudes_dtazv_export.add_t.size.should == 256
  end

  it "should return the proper W segment" do
    # @dudes_dtazv_export.add_t.should == "..........."
  end

  it "should return the proper length of W segment" do
    # @dudes_dtazv_export.add_t.size.should == 256
  end

  it "should return the proper Y segment" do
    # @dudes_dtazv_export.add_t.should == "..........."
  end

  it "should return the proper length of Y segment" do
    # @dudes_dtazv_export.add_t.size.should == 256
  end

end
