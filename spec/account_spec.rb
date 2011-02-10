require 'spec_helper'

describe KingDta::Account do

  before :each do
    @ba = test_kto2 # BankAccount mocked as open struct
  end

  it "should initialize a new account" do
    lambda{ KingDta::Account.new(@ba.nr, @ba.blz, @ba.name) }.should_not raise_error
  end

  it "should fail if bank account number is invalid" do
    # not 0
    lambda{ KingDta::Account.new(0, @ba.blz, @ba.name) }.should raise_error(ArgumentError)
    # max 10
    lambda{ KingDta::Account.new(123456789011, @ba.blz, @ba.name) }.should raise_error(ArgumentError, 'Bank account number too long, max 10 allowed')
  end

  it "should fail if bank number is invalid" do
    # not 0
    lambda{ KingDta::Account.new(@ba.nr, 0, @ba.name) }.should raise_error(ArgumentError)
    # max 8
    lambda{ KingDta::Account.new(@ba.nr, 123456789, @ba.name) }.should raise_error(ArgumentError, 'Bank number too long, max 8 allowed')
  end

  it "should fail if clent number is too long" do
    # max 10
    lambda{ KingDta::Account.new(@ba.nr, @ba.blz, @ba.name, 12345678901) }.should raise_error(ArgumentError, 'Client number too long, max 10 allowed')
  end
  
end
