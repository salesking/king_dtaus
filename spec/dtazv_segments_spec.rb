require 'spec/spec_helper'
# All Test DTAZV output strings are validated with sFirm => lokal Sparkassen Software
describe KingDta::DtazvSegments do

  before :each do
    @dudes_dtazv_export = KingDta::Dtazv.new(Date.today)
    @dudes_konto = dudes_konto
    @dudes_dtazv_export.account = KingDta::Account.new(
                        @dudes_konto.account_nr,
                        @dudes_konto.account_bank_number,
                        @dudes_konto.sender_name,
                        @dudes_konto.client_number,
                        @dudes_konto.account_street,
                        @dudes_konto.account_city,
                        @dudes_konto.account_zip_code,
                        @dudes_konto.account_bank_name,
                        @dudes_konto.sender_street,
                        @dudes_konto.sender_city,
                        @dudes_konto.sender_zip_code
                      )
  end

  it "should return the proper P segment" do
    @dudes_dtazv_export.add_p.should == "0256P37040044                                                     Commerzbank K\303\266ln                   5th avenue 55323                        los angeles1106060100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
  end

  it "should return the proper length of P segment" do
    @dudes_dtazv_export.add_p.size.should == 256
  end

  it "should return the proper Q segment" do
    @dudes_dtazv_export.add_q.should == "0256Q370400447828970037                                                   GIMME YOUR MONEY AG                  6th avenue 445555                        los angeles11060601110606N 03704004400000000000000000000000000000000000000000000000000000000000000000000"
    puts @dudes_dtazv_export.add_q
  end

  it "should return the proper length of P segment" do
    @dudes_dtazv_export.add_q.size.should == 256
  end

end
