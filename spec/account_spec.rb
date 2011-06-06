require 'spec/spec_helper'

describe KingDta::Account do

  before :each do
    @ba = test_kto2 # BankAccount mocked as open struct
    @dudes_konto = dudes_konto
  end

  it "should initialize a new account" do
    lambda{ KingDta::Account.new(@ba.account_nr, @ba.account_bank_number, @ba.sender_name) }.should_not raise_error
  end

  it "should initialize a new dtazv account" do
    lambda{ KingDta::Account.new(
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
          )}.should_not raise_error
  end

  it "should fail if bank account number is invalid" do
    # not 0
    lambda{ KingDta::Account.new(0, @ba.account_bank_number, @ba.sender_name) }.should raise_error(ArgumentError)
    # max 10
    lambda{ KingDta::Account.new(123456789011, @ba.account_bank_number, @ba.sender_name) }.should raise_error(ArgumentError, 'Bank account number too long, max 10 allowed')
  end

  it "should fail if bank number is invalid" do
    # not 0
    lambda{ KingDta::Account.new(@ba.account_nr, 0, @ba.sender_name) }.should raise_error(ArgumentError)
    # max 8
    lambda{ KingDta::Account.new(@ba.account_nr, 123456789, @ba.sender_name) }.should raise_error(ArgumentError, 'Bank number too long, max 8 allowed')
  end

  it "should fail if clent number is too long" do
    # max 10
    lambda{ KingDta::Account.new(@ba.account_nr, @ba.account_bank_number, @ba.sender_name, 12345678901) }.should raise_error(ArgumentError, 'Client number too long, max 10 allowed')
  end

  it "should fail if street and/or Zip Code is too long" do
    lambda{ KingDta::Account.new(
            @dudes_konto.account_nr,
            @dudes_konto.account_bank_number,
            @dudes_konto.sender_name,
            @dudes_konto.client_number,
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            @dudes_konto.account_city,
            @dudes_konto.account_zip_code,
            @dudes_konto.account_bank_name,
            @dudes_konto.sender_street,
            @dudes_konto.sender_city,
            @dudes_konto.sender_zip_code
          )}.should raise_error(ArgumentError, 'Street and/or Zip Code too long, max 35 allowed')
  end

  it "should fail if city is too long" do
    lambda{ KingDta::Account.new(
            @dudes_konto.account_nr,
            @dudes_konto.account_bank_number,
            @dudes_konto.sender_name,
            @dudes_konto.client_number,
            @dudes_konto.account_street,
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            @dudes_konto.account_zip_code,
            @dudes_konto.account_bank_name,
            @dudes_konto.sender_street,
            @dudes_konto.sender_city,
            @dudes_konto.sender_zip_code
          )}.should raise_error(ArgumentError, 'City too long, max 35 allowed')
  end

  it "should fail if bank name is too long" do
    lambda{ KingDta::Account.new(
            @dudes_konto.account_nr,
            @dudes_konto.account_bank_number,
            @dudes_konto.sender_name,
            @dudes_konto.client_number,
            @dudes_konto.account_street,
            @dudes_konto.account_city,
            @dudes_konto.account_zip_code,
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            @dudes_konto.sender_street,
            @dudes_konto.sender_city,
            @dudes_konto.sender_zip_code
          )}.should raise_error(ArgumentError, 'Bank Name too long, max 35 allowed')
  end

  it "should fail if sender street and/or zipcode is too long" do
    lambda{ KingDta::Account.new(
            @dudes_konto.account_nr,
            @dudes_konto.account_bank_number,
            @dudes_konto.sender_name,
            @dudes_konto.client_number,
            @dudes_konto.account_street,
            @dudes_konto.account_city,
            @dudes_konto.account_zip_code,
            @dudes_konto.account_bank_name,
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            @dudes_konto.sender_city,
            @dudes_konto.sender_zip_code
          )}.should raise_error(ArgumentError, 'Sender Street and/or Zip Code too long, max 35 allowed')
  end

  it "should fail if city is too long" do
    lambda{ KingDta::Account.new(
            @dudes_konto.account_nr,
            @dudes_konto.account_bank_number,
            @dudes_konto.sender_name,
            @dudes_konto.client_number,
            @dudes_konto.account_street,
            @dudes_konto.account_city,
            @dudes_konto.account_zip_code,
            @dudes_konto.account_bank_name,
            @dudes_konto.sender_street,
            "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            @dudes_konto.sender_zip_code
          )}.should raise_error(ArgumentError, 'Sender City too long, max 35 allowed')
  end

  it "should return account street and zip" do
    konto = KingDta::Account.new(
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
    konto.account_street_zip.should == "5th avenue 55323"
  end

  it "should return sender street and zip" do
    konto = KingDta::Account.new(
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
    konto.sender_street_zip.should == "6th avenue 445555"
  end

end
