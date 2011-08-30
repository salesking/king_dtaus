# encoding: utf-8
require 'spec_helper'

describe KingDta::Account do

  before :each do
    @ba = test_kto2 # BankAccount mocked as open struct
    @dudes_konto = dudes_konto
  end

  it "should initialize a new account" do
    lambda{ KingDta::Account.new(:account_number => @ba.account_number, :bank_number => @ba.bank_number, :client_name => @ba.client_name) }.should_not raise_error
  end

  it "should initialize a new dtazv account" do
    lambda{ KingDta::Account.new(
              :account_number =>    @dudes_konto.account_number,
              :bank_number =>       @dudes_konto.bank_number,
              :client_name =>       @dudes_konto.client_name,
              :client_number =>     @dudes_konto.client_number,
              :bank_street =>       @dudes_konto.account_street,
              :bank_city =>         @dudes_konto.account_city,
              :bank_zip_code =>     @dudes_konto.account_zip_code,
              :bank_name =>         @dudes_konto.bank_name,
              :client_street =>     @dudes_konto.client_street,
              :client_city =>       @dudes_konto.client_city,
              :client_zip_code =>   @dudes_konto.client_zip_code
          )}.should_not raise_error
  end

  it "should fail if bank account number is invalid" do
    # lambda{ KingDta::Account.new(0, @ba.bank_number, @ba.client_name) }.should raise_error(ArgumentError)
    lambda{ KingDta::Account.new(:account_number => 123456789011123456789011123456789011123456789011123456789011123456789011, :bank_number => @ba.bank_number, :client_name => @ba.client_name) }.should raise_error(ArgumentError, 'Account number too long, max 35 allowed')
  end

  it "should fail if bank number is invalid" do
    lambda{ KingDta::Account.new(:account_number => @ba.account_number, :bank_number => 0, :client_name => @ba.client_name) }.should raise_error(ArgumentError)
    lambda{ KingDta::Account.new(:account_number => @ba.account_number, :bank_number => 123456789101112, :client_name => @ba.client_name) }.should raise_error(ArgumentError, 'Bank number too long, max 11 allowed')
  end

  it "should fail if clent number is too long" do
    lambda{ KingDta::Account.new(:account_number => @ba.account_number, :bank_number => @ba.bank_number, :client_name => @ba.client_name, :client_number => 12345678901) }.should raise_error(ArgumentError, 'Client number too long, max 10 allowed')
  end

  it "should fail if street and/or Zip Code is too long" do
    lambda{ KingDta::Account.new(
            :account_number =>    @dudes_konto.account_number,
            :bank_number =>       @dudes_konto.bank_number,
            :client_name =>       @dudes_konto.client_name,
            :client_number =>     @dudes_konto.client_number,
            :bank_street =>       "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            :bank_city =>         @dudes_konto.account_city,
            :bank_zip_code =>     @dudes_konto.account_zip_code,
            :bank_name =>         @dudes_konto.bank_name,
            :client_street =>     @dudes_konto.client_street,
            :client_city =>       @dudes_konto.client_city,
            :client_zip_code =>   @dudes_konto.client_zip_code
          )}.should raise_error(ArgumentError, 'Street and/or Zip Code too long, max 35 allowed')
  end

  it "should fail if city is too long" do
    lambda{ KingDta::Account.new(
            :account_number =>    @dudes_konto.account_number,
            :bank_number =>       @dudes_konto.bank_number,
            :client_name =>       @dudes_konto.client_name,
            :client_number =>     @dudes_konto.client_number,
            :bank_street =>       @dudes_konto.account_street,
            :bank_city =>         "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            :bank_zip_code =>     @dudes_konto.account_zip_code,
            :bank_name =>         @dudes_konto.account_bank_name,
            :client_street =>     @dudes_konto.client_street,
            :client_city =>       @dudes_konto.client_city,
            :client_zip_code =>   @dudes_konto.client_zip_code
          )}.should raise_error(ArgumentError, 'City too long, max 35 allowed')
  end

  it "should fail if bank name is too long" do
    lambda{ KingDta::Account.new(
            :account_number =>    @dudes_konto.account_number,
            :bank_number =>       @dudes_konto.bank_number,
            :client_name =>       @dudes_konto.client_name,
            :client_number =>     @dudes_konto.client_number,
            :bank_street =>       @dudes_konto.account_street,
            :bank_city =>         @dudes_konto.account_city,
            :bank_zip_code =>     @dudes_konto.account_zip_code,
            :bank_name =>         "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            :client_street =>     @dudes_konto.client_street,
            :client_city =>       @dudes_konto.client_city,
            :client_zip_code =>   @dudes_konto.client_zip_code
          )}.should raise_error(ArgumentError, 'Bank Name too long, max 35 allowed')
  end

  it "should fail if sender street and/or zipcode is too long" do
    lambda{ KingDta::Account.new(
            :account_number =>    @dudes_konto.account_number,
            :bank_number =>       @dudes_konto.bank_number,
            :client_name =>       @dudes_konto.client_name,
            :client_number =>     @dudes_konto.client_number,
            :bank_street =>       @dudes_konto.account_street,
            :bank_city =>         @dudes_konto.account_city,
            :bank_zip_code =>     @dudes_konto.account_zip_code,
            :bank_name =>         @dudes_konto.bank_name,
            :client_street =>     "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            :client_city =>       @dudes_konto.client_city,
            :client_zip_code =>   @dudes_konto.client_zip_code
          )}.should raise_error(ArgumentError, 'Client Street and/or Zip Code too long, max 35 allowed')
  end

  it "should fail if city is too long" do
    lambda{ KingDta::Account.new(
            :account_number =>    @dudes_konto.account_number,
            :bank_number =>       @dudes_konto.bank_number,
            :client_name =>       @dudes_konto.client_name,
            :client_number =>     @dudes_konto.client_number,
            :bank_street =>       @dudes_konto.account_street,
            :bank_city =>         @dudes_konto.account_city,
            :bank_zip_code =>     @dudes_konto.account_zip_code,
            :bank_name =>         @dudes_konto.bank_name,
            :client_street =>     @dudes_konto.client_street,
            :client_city =>       "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            :client_zip_code =>   @dudes_konto.client_zip_code
          )}.should raise_error(ArgumentError, 'Client City too long, max 35 allowed')
  end

  it "should return account street and zip" do
    konto = KingDta::Account.new(
      :account_number =>    @dudes_konto.account_number,
      :bank_number =>       @dudes_konto.bank_number,
      :client_name =>       @dudes_konto.client_name,
      :client_number =>     @dudes_konto.client_number,
      :bank_street =>       @dudes_konto.account_street,
      :bank_city =>         @dudes_konto.account_city,
      :bank_zip_code =>     @dudes_konto.account_zip_code,
      :bank_name =>         @dudes_konto.bank_name,
      :client_street =>     @dudes_konto.client_street,
      :client_city =>       @dudes_konto.client_city,
      :client_zip_code =>   @dudes_konto.client_zip_code
    )
    konto.zip_city.should == "51063 BANK KOELN"
  end

  it "should return sender street and zip" do
    konto = KingDta::Account.new(
      :account_number =>    @dudes_konto.account_number,
      :bank_number =>       @dudes_konto.bank_number,
      :client_name =>       @dudes_konto.client_name,
      :client_number =>     @dudes_konto.client_number,
      :bank_street =>       @dudes_konto.account_street,
      :bank_city =>         @dudes_konto.account_city,
      :bank_zip_code =>     @dudes_konto.account_zip_code,
      :bank_name =>         @dudes_konto.bank_name,
      :client_street =>     @dudes_konto.client_street,
      :client_city =>       @dudes_konto.client_city,
      :client_zip_code =>   @dudes_konto.client_zip_code
    )
    konto.client_zip_city.should == "51063 MEINE KOELN"
  end


end
