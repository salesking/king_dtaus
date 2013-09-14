# encoding: utf-8
require 'spec_helper'

# All Test DTAZV output strings are validated with sFirm => lokal Sparkassen Software

describe KingDta::Dtazv do
  context "support for non-EUR currency" do
    before do
      @dtazv = KingDta::Dtazv.new(Date.parse('2011-08-28'))
      @dtazv.account = KingDta::Account.new sender_opts
      @booking = KingDta::Booking.new(KingDta::Account.new(swiss_receiver), 235.42, nil, nil, "CHF")
    end

    # FIXME: Write better tests later
    it "should at least not raise an error" do
      @dtazv.add(@booking)
      @dtazv.create
    end
  end

  before :each do
    @dtazv = KingDta::Dtazv.new(Date.parse('2011-08-28'))
    @dtazv.account = KingDta::Account.new sender_opts
    @booking = KingDta::Booking.new( KingDta::Account.new( receiver_opts ), 220.25)
  end

  it "should init without values" do
    lambda{ KingDta::Dtazv.new }.should_not raise_error
  end

  it "should init with valid values" do
    lambda{ KingDta::Dtazv.new(Date.today) }.should_not raise_error
  end

  it "should not init with an invalid date" do
    lambda{ KingDta::Dtazv.new("date") }.should raise_error(ArgumentError)
  end

  it "should deny invalid accounts" do
    lambda{ @dtazv.account = "account" }.should raise_error(KingDta::Exception)
  end

  it "should create file" do
    @dtazv.default_text = 'Default Verwendungszweck'
    6.times { @dtazv.add(@booking) }
    # create test output file in spec dir
    filename = File.join(File.dirname(__FILE__), 'test_output.dta')
    @dtazv.create_file(filename)
    str = ''
    File.open(filename, 'r').each { |ln| str << ln }
    str.length.should == 5120
    #remove testfile
    File.delete(filename)
  end

  it "should not add a booking if closed" do
    @dtazv.add(@booking)
    @dtazv.create
    lambda{ @dtazv.add(@booking) }.should raise_error(KingDta::Exception)
  end

  it "should not add a booking if closed" do
    @dtazv.add(@booking)
    negative_booking = KingDta::Booking.new(KingDta::Account.new( receiver_opts ), -220.25)
    lambda{ @dtazv.add(negative_booking) }.should raise_error(KingDta::Exception)
  end

  it "should not create if there are no bookings" do
    lambda{ @dtazv.create}.should raise_error(KingDta::Exception)
  end

  it "should create the whole dta string with a single booking" do
    @dtazv.add(@booking)
    str = @dtazv.create
    str.length.should == 1280
    str.should include(receiver_opts[:owner_name].upcase)
    out = "0256Q370502991326049634JAN KUS                                                               MEINE EINE STRASSE 2               51063 MEINE KOELN                  11082801110828N0000000000                                                                    0768T37050299EUR132604963411082800000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250                                                                                                                                            00000000                         0013                                                              0                                                   000256Z000000000000220000000000000001                                                                                                                                                                                                                             "
    str.should == out
  end

  it "should create whole dta string with long booking text in extension" do
    @dtazv.add(@booking)
    @dtazv.bookings.first.text = 'Rgn R-3456-0102220 Monatsbeitrag 08/10 Freelancer Version Vielen Dank Ihre SalesKing GmbH'
    str = @dtazv.create
    str.length.should == 1280
    str.should include(receiver_opts[:owner_name].upcase)
    out = "0256Q370502991326049634JAN KUS                                                               MEINE EINE STRASSE 2               51063 MEINE KOELN                  11082801110828N0000000000                                                                    0768T37050299EUR132604963411082800000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250RGN R-3456-0102220 MONATSBEITRAG 08/10 FREELANCER VERSION VIELEN DANK IHRE SALESKING GMBH                                                   00000000                         0013                                                              0                                                   000256Z000000000000220000000000000001                                                                                                                                                                                                                             "
    str.should == out
  end

  it "should create the whole dta string with a lot of bookings" do
    6.times { @dtazv.add(@booking) }
    str = @dtazv.create
    str.length.should == 5120
    str.should include(receiver_opts[:owner_name].upcase)
    str.should include(sender_opts[:owner_name].upcase)
    out = "0256Q370502991326049634JAN KUS                                                               MEINE EINE STRASSE 2               51063 MEINE KOELN                  11082801110828N0000000000                                                                    0768T37050299EUR132604963411082800000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250                                                                                                                                            00000000                         0013                                                              0                                                   000768T37050299EUR132604963411082800000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250                                                                                                                                            00000000                         0013                                                              0                                                   000768T37050299EUR132604963411082800000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250                                                                                                                                            00000000                         0013                                                              0                                                   000768T37050299EUR132604963411082800000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250                                                                                                                                            00000000                         0013                                                              0                                                   000768T37050299EUR132604963411082800000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250                                                                                                                                            00000000                         0013                                                              0                                                   000768T37050299EUR132604963411082800000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250                                                                                                                                            00000000                         0013                                                              0                                                   000256Z000000000001320000000000000006                                                                                                                                                                                                                             "
    str.should == out
  end

end

describe "KingDta::DtazvSegments" do

  before :each do
    @date = Date.today
    @dtazv = KingDta::Dtazv.new(@date)
    @dtazv.account = KingDta::Account.new( sender_opts)
    @booking = KingDta::Booking.new(KingDta::Account.new( receiver_opts ), 220.25)

    @bookings = [@booking]
  end


  # P SEGMENT NOT IMPLEMENTED AND USED YET
  # it "should return the proper P segment" do
  #   @dtazv.add_p.should == "0256P37040044                                                     Commerzbank K\303\266ln                   5th avenue 55323                        los angeles11060801                                                                                               "
  # end

  # it "should return the proper length of P segment" do
  #   @dtazv.add_p.size.should == 256
  # end

  it "should return the proper Q segment" do
    @dtazv.add_q.should == "0256Q370502991326049634JAN KUS                                                               MEINE EINE STRASSE 2               51063 MEINE KOELN                  #{@date.strftime("%y%m%d")}01#{@date.strftime("%y%m%d")}N0000000000                                                                    "
  end

  it "should return the proper length of P segment" do
    @dtazv.add_q.size.should == 256
  end

  it "should return the proper T segment" do
    @dtazv.add_t(@booking).should == "0768T37050299EUR1326049634#{@date.strftime("%y%m%d")}00000000   0000000000COBADEFF366                                                                                                                                               DE DALAI LAMA                                                            BUSH-AVENUE 55                     445555 INDIA                                                                                             /PL10105013151000002308622378      EUR00000000000220250                                                                                                                                            00000000                         0013                                                              0                                                   00"
  end

  it "should return the proper length of T segment" do
    @dtazv.add_t(@booking).size.should == 768
  end

  # V SEGMENT NOT IMPLEMENTED AND USED YET
  # it "should return the proper V segment" do
  #   @dtazv.add_t.should == "..........."
  # end

  # it "should return the proper length of V segment" do
  #   @dtazv.add_t.size.should == 256
  # end

  # W SEGMENT NOT IMPLEMENTED AND USED YET
  # it "should return the proper W segment" do
  #   @dtazv.add_t.should == "..........."
  # end

  # it "should return the proper length of W segment" do
  #   @dtazv.add_t.size.should == 256
  # end

  it "should return the proper Y segment" do
    @dtazv.add_y(@bookings).should == "0256Y000000000000000000000000000000000000000000000000000000000000000000000001                                                                                                                                                                                   "
  end

  it "should return the proper length of Y segment" do
    @dtazv.add_y(@bookings).size.should == 256
  end

  it "should return the proper Z segment" do
    @dtazv.add_z(@bookings).should == "0256Z000000000000220000000000000001                                                                                                                                                                                                                             "
  end

  it "should return the proper length of Z segment" do
    @dtazv.add_z(@bookings).size.should == 256
  end

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

end
