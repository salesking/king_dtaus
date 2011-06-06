require 'spec/spec_helper'

describe KingDta::Account do

  before :each do
    @ba = test_kto2 # BankAccount mocked as open struct
    @dudes_konto = dudes_konto
  end

  it "should initialize a new account" do
    lambda{ KingDta::Account.new(@ba.nr, @ba.blz, @ba.name) }.should_not raise_error
  end

  it "should initialize a new dtazv account" do
    lambda{ KingDta::Account.new(
            @dudes_konto.nr,
            @dudes_konto.blz,
            @dudes_konto.account_name,
            @dudes_konto.client_number,
            @dudes_konto.street,
            @dudes_konto.city,
            @dudes_konto.zip_code,
            @dudes_konto.bank_name
          )}.should_not raise_error
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

  it "should fail if street is too long" do
    lambda{ KingDta::Account.new(
            @dudes_konto.nr,
            @dudes_konto.blz,
            @dudes_konto.account_name,
            @dudes_konto.client_number,
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            @dudes_konto.city,
            @dudes_konto.zip_code,
            @dudes_konto.bank_name
          )}.should raise_error(ArgumentError, 'Street too long, max 35 allowed')
  end

  it "should fail if city is too long" do
    lambda{ KingDta::Account.new(
            @dudes_konto.nr,
            @dudes_konto.blz,
            @dudes_konto.account_name,
            @dudes_konto.client_number,
            @dudes_konto.street,
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            @dudes_konto.zip_code,
            @dudes_konto.bank_name
          )}.should raise_error(ArgumentError, 'City too long, max 35 allowed')
  end

  it "should fail if zipcode is too long" do
    lambda{ KingDta::Account.new(
            @dudes_konto.nr,
            @dudes_konto.blz,
            @dudes_konto.account_name,
            @dudes_konto.client_number,
            @dudes_konto.street,
            @dudes_konto.city,
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            @dudes_konto.bank_name
          )}.should raise_error(ArgumentError, 'Zip-Code too long, max 35 allowed')
  end

  it "should fail if bank name is too long" do
    lambda{ KingDta::Account.new(
            @dudes_konto.nr,
            @dudes_konto.blz,
            @dudes_konto.account_name,
            @dudes_konto.client_number,
            @dudes_konto.street,
            @dudes_konto.city,
            @dudes_konto.zip_code,
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
          )}.should raise_error(ArgumentError, 'Bank Name too long, max 35 allowed')
  end

end
