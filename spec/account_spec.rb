# encoding: utf-8
require 'spec_helper'

describe KingDta::Account do

  before :each do
    @ba = test_kto2 # BankAccount mocked as open struct
  end

  it "should initialize a new account" do
    lambda{ KingDta::Account.new(:account_number => @ba.account_number, :bank_number => @ba.bank_number, :client_name => @ba.client_name) }.should_not raise_error
  end

  it "should initialize a new dtazv account" do
    lambda{ 
      KingDta::Account.new(sender_opts)
    }.should_not raise_error
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
    opts = sender_opts.merge( :bank_street => "Lorem ipsum dolor sit amet, consectetur")
    lambda{
      KingDta::Account.new(opts)
    }.should raise_error(ArgumentError, 'Bank Street too long, max 35 allowed')
  end

  it "should fail if city is too long" do
    opts = sender_opts.merge( :bank_city => "Lorem ipsum dolor sit amet, consecte")
    lambda{ 
      KingDta::Account.new opts
    }.should raise_error(ArgumentError, 'Bank City too long, max 35 allowed')
  end

  it "should fail if bank name is too long" do
    opts = sender_opts.merge( :bank_name => "Lorem ipsum dolor sit amet, consecte")
    lambda{
      KingDta::Account.new opts
    }.should raise_error(ArgumentError, 'Bank Name too long, max 35 allowed')
  end

  it "should fail if client street is too long" do
    opts = sender_opts.merge( :client_street => "Lorem ipsum dolor sit amet, consecte")
    lambda{
      KingDta::Account.new opts
    }.should raise_error(ArgumentError, 'Client Street too long, max 35 allowed')
  end

  it "should fail if city is too long" do
    opts = sender_opts.merge( :client_city => "Lorem ipsum dolor sit amet, consecte")
    lambda{
      KingDta::Account.new opts
    }.should raise_error(ArgumentError, 'Client City too long, max 35 allowed')
  end

  it "should return account street and zip" do
    konto = KingDta::Account.new( sender_opts )
    konto.zip_city.should == "51063 BANK KOELN"
  end

  it "should return sender street and zip" do
    konto = KingDta::Account.new( sender_opts )
    konto.client_zip_city.should == "51063 MEINE KOELN"
  end
end