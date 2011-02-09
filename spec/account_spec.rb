require "#{File.dirname(__FILE__)}/spec_helper"

describe KingDta::Account do

  before :each do
    @bank_account = test_kto2
  end

  it "should initialize a new account" do
    lambda{ KingDta::Account.new(@bank_account.nr, @bank_account.blz, @bank_account.name, @bank_account.bank) }.should_not raise_error
  end

  it "should fail if bank account number is invalid" do
    lambda{ KingDta::Account.new(0, @bank_account.blz, @bank_account.name, @bank_account.bank) }.should raise_error(KingDta::Exception)
  end

  it "should fail if bank number is invalid" do
    lambda{ KingDta::Account.new(@bank_account.nr, 0, @bank_account.name, @bank_account.bank) }.should raise_error(KingDta::Exception)
  end
  
end
