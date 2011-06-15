# encoding: utf-8
module KingDta
  #Kontodaten verwalten mit Name des Inhabers und Bank, Bankleitzahl und Kontonummer.
  class Account
    include KingDta::Helper
    # dta~ jeweilige Feld in DTAUS-Norm
    attr_accessor :account_number, :bank_number, :client_number, :bank_street, :bank_city, :bank_zip_code, :bank_name,
:client_name, :client_street, :client_city, :client_zip_code, :bank_country_code, :client_country_code

    # TODO test
    def initialize(args={})

      @bank_street = convert_text(args.delete(:bank_street))
      @bank_city = convert_text(args.delete(:bank_city))
      @bank_name = convert_text(args.delete(:bank_name))
      @client_name = convert_text(args.delete(:client_name))
      @client_street = convert_text(args.delete(:client_street))
      @client_city = convert_text(args.delete(:client_city))

      args.each do |key,value|
        self.send("#{key}=",value)
      end

      raise ArgumentError.new('Account number too long, max 35 allowed') if @account_number && "#{@account_number}".length > 35
      raise ArgumentError.new('Bank number too long, max 11 allowed') if @bank_number && "#{@bank_number}".length > 11
      raise ArgumentError.new('Client number too long, max 10 allowed') if @client_number && "#{@client_number}".length > 10
      raise ArgumentError.new("Bank account number cannot be 0")  if @account_number && @account_number == 0
      raise ArgumentError.new("Bank number cannot be 0")   if @bank_number && @bank_number == 0
      raise ArgumentError.new("Street and/or Zip Code too long, max 35 allowed") if @bank_street && @bank_zip_code && "#{@bank_street} #{@bank_zip_code}".length > 35
      raise ArgumentError.new("City too long, max 35 allowed") if @bank_city && @bank_city.length > 35
      raise ArgumentError.new("Bank Name too long, max 35 allowed") if @bank_name && @bank_name.length > 35
      raise ArgumentError.new("Client Street and/or Zip Code too long, max 35 allowed") if @client_street && @client_zip_code && "#{@client_street} #{@client_zip_code}".length > 35
      raise ArgumentError.new("Client City too long, max 35 allowed") if @client_city && @client_city.length > 35
      raise ArgumentError.new("Bank Country code too long, max 2 allowed") if @bank_country_code && @bank_country_code.length > 2
      raise ArgumentError.new("Client Country code too long, max 2 allowed") if @client_country_code && @client_country_code.length > 2

    end

    # TODO test
    def client_firstname
      @client_name.split(' ')[0]
    end

    def client_surname
      @client_name.split(' ')[1]
    end

    def zip_city
      "#{@bank_zip_code} #{@bank_city}"
    end

    def client_zip_city
      "#{@client_zip_code} #{@client_city}"
    end

  end
end
