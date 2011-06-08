require 'spec/spec_helper'
# All Test DTAZV output strings are validated with sFirm => lokal Sparkassen Software
describe KingDta::DtazvSegments do

  before :each do
    @date = Date.today
    @dudes_dtazv_export = KingDta::Dtazv.new(@date)
    @dudes_konto = dudes_konto
    @fidel_castros_account = fidel_castros_account
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

    @bookings = []
    @bookings << @fidel_castros_booking
  end


  # P SEGMENT NOT IMPLEMENTED AND USED YET
  # it "should return the proper P segment" do
  #   @dudes_dtazv_export.add_p.should == "0256P37040044                                                     Commerzbank K\303\266ln                   5th avenue 55323                        los angeles11060801                                                                                               "
  # end

  # it "should return the proper length of P segment" do
  #   @dudes_dtazv_export.add_p.size.should == 256
  # end

  it "should return the proper Q segment" do
    @dudes_dtazv_export.add_q.should == "0256Q370502991326049634JAN                                KUS                                MEINE EINE STRASSE 2               51063 MEINE KOELN                  11060801110608N0000000000                                                                    "
  end

  it "should return the proper length of P segment" do
    @dudes_dtazv_export.add_q.size.should == 256
  end

  it "should return the proper T segment" do
    @dudes_dtazv_export.add_t(@fidel_castros_booking).should == "0768T37050299EUR132604963411060800000000   0000000000MARKF1100                                                                                                                                                 DE FIDEL                              CASTRO                             BUSH-AVENUE 55                     445555 KUBA                                                                                              /GR1601101250000000012300695       EUR00000000000220250                                                                                                                                            00000000                         0013                                                              0                                                   00"
  end

  it "should return the proper length of T segment" do
    @dudes_dtazv_export.add_t(@fidel_castros_booking).size.should == 768
  end

  # V SEGMENT NOT IMPLEMENTED AND USED YET
  # it "should return the proper V segment" do
  #   @dudes_dtazv_export.add_t.should == "..........."
  # end

  # it "should return the proper length of V segment" do
  #   @dudes_dtazv_export.add_t.size.should == 256
  # end

  # V SEGMENT NOT IMPLEMENTED AND USED YET
  # it "should return the proper W segment" do
  #   @dudes_dtazv_export.add_t.should == "..........."
  # end

  # it "should return the proper length of W segment" do
  #   @dudes_dtazv_export.add_t.size.should == 256
  # end

  # P SEGMENT NOT IMPLEMENTED AND USED YET
  # it "should return the proper Y segment" do
  #   @dudes_dtazv_export.add_y(1).should == "........."
  # end

  # it "should return the proper length of Y segment" do
  #   @dudes_dtazv_export.add_y(1).size.should == 256
  # end

  it "should return the proper Z segment" do
    @dudes_dtazv_export.add_z(@bookings).should == "0256Z000000000000220000000000000001                                                                                                                                                                                                                             "
  end

  it "should return the proper length of Z segment" do
    @dudes_dtazv_export.add_z(@bookings).size.should == 256
  end

end
