# encoding: utf-8
module KingDta
  #Kontodaten verwalten mit Name des Inhabers und Bank, Bankleitzahl und Kontonummer.
  class Account
    include KingDta::Helper
    # dta~ jeweilige Feld in DTAUS-Norm
    attr_reader(  :account_number, :bank_number, :client_number,
                  :street, :city, :zip_code, :bank_name,
                  :client_name, :client_street, :client_city, :client_zip_code,
                  :bank_country_code, :client_country_code)

    def initialize( account_number, bank_number, client_name, client_number="",
                    street = nil, city = nil, zip_code = nil, bank_name = nil,
                    client_street = nil, client_city = nil, client_zip_code = nil,
                    bank_country_code = nil, client_country_code = nil
                  )

      @account_number         = account_number #account_number.kind_of?( Integer ) ? account_number : account_number.gsub(/\s/, '').to_i
      @bank_number            = bank_number #bank_number.kind_of?( Integer ) ? bank_number :  bank_number.gsub(/\s/, '').to_i
      @client_number          = client_number.kind_of?( Integer ) ? client_number : client_number.gsub(/\s/, '').to_i
      @street                 = convert_text(street)
      @city                   = convert_text(city)
      @zip_code               = zip_code
      @bank_name              = convert_text(bank_name)
      @client_name            = convert_text(client_name)
      @client_street          = convert_text(client_street)
      @client_city            = convert_text(client_city)
      @client_zip_code        = client_zip_code
      # TODO test
      @bank_country_code      = bank_country_code
      @client_country_code    = client_country_code

      raise ArgumentError.new('Account number too long, max 35 allowed') if @account_number && "#{@account_number}".length > 35
      raise ArgumentError.new('Bank number too long, max 11 allowed') if @bank_number && "#{@bank_number}".length > 11
      raise ArgumentError.new('Client number too long, max 10 allowed') if @client_number && "#{@client_number}".length > 10
      raise ArgumentError.new("Bank account number cannot be 0")  if @account_number && @account_number == 0
      raise ArgumentError.new("Bank number cannot be 0")   if @bank_number && @bank_number == 0
      raise ArgumentError.new("Street and/or Zip Code too long, max 35 allowed") if @street && @zip_code && "#{@street} #{@zip_code}".length > 35
      raise ArgumentError.new("City too long, max 35 allowed") if @city && @city.length > 35
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
      "#{@zip_code} #{@city}"
    end

    def client_zip_city
      "#{@client_zip_code} #{@client_city}"
    end

  end
end
