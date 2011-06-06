require 'spec/spec_helper'
# All Test DTAZV output strings are validated with sFirm => lokal Sparkassen Software
describe KingDta::DtazvSegments do

  before :each do
    @dudes_dtazv_export = KingDta::Dtazv.new(Date.today)
    @dudes_konto = dudes_konto
    @dudes_dtazv_export.account = KingDta::Account.new(
                        @dudes_konto.nr,
                        @dudes_konto.blz,
                        @dudes_konto.name,
                        @dudes_konto.street,
                        @dudes_konto.city,
                        @dudes_konto.zip_code,
                        @dudes_konto.bank_name
                      )
  end

  it "should return the proper P segment" do
    @dudes_dtazv_export.add_p.should == "0256P37040044                                                     Commerzbank Köln                         5th avenue                        los angeles1106060100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
  end

  it "should return the proper length of P segment" do
    @dudes_dtazv_export.add_p.size.should == 256
  end

end
