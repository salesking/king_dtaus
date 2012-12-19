# encoding: utf-8

require 'spec_helper'

describe KingDta:: SumupDtaus do

  before :each do
    @sumup_dtaus = KingDta::SumupDtaus.new('GK')
    @kto1 = test_kto1
    @kto2 = test_kto2
    @sumup_dtaus.account = KingDta::Account.new(:bank_account_number => @kto1.bank_account_number, :bank_number => @kto1.bank_number, :owner_name => @kto1.owner_name, :bank_name => @kto1.bank_name)
    # TODO: Finish writing this test with DtausBooking, need to write tests for that first though.
    @booking = KingDta::DtausBooking.new(KingDta::Account.new(:bank_account_number => @kto2.bank_account_number, :bank_number => @kto2.bank_number, :owner_name => @kto2.owner_name, :bank_name => @kto2.bank_name), 220.25 )
    @booking.text = ["lololololl", "laflaflaflaflaflaf"]
  end

end
