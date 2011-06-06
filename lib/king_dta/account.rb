# encoding: utf-8
module KingDta
  #Kontodaten verwalten mit Name des Inhabers und Bank, Bankleitzahl und Kontonummer.
  class Account
    include KingDta::Helper
    # dta~ jeweilige Feld in DTAUS-Norm
    attr_reader  :bank_account_number, :bank_number, :client_number, :street, :city, :zip_code, :bank_name, :sender_name, :sender_street, :sender_city, :sender_zip_code

    def initialize( bank_account_number, bank_number, sender_name, client_number="",
                    street = nil, city = nil, zip_code = nil, bank_name = nil,
                    sender_street = nil, sender_city = nil, sender_zip_code = nil
                  )

      @bank_account_number   = bank_account_number.kind_of?( Integer ) ? bank_account_number : bank_account_number.gsub(/\s/, '').to_i
      @bank_number           = bank_number.kind_of?( Integer ) ? bank_number :  bank_number.gsub(/\s/, '').to_i
      @client_number         = client_number.kind_of?( Integer ) ? client_number : client_number.gsub(/\s/, '').to_i
      @street                = street
      @city                  = city
      @zip_code              = zip_code
      @bank_name             = bank_name
      @sender_name           = convert_text( sender_name )
      @sender_street         = sender_street
      @sender_city           = sender_city
      @sender_zip_code       = sender_zip_code

      raise ArgumentError.new('Bank account number too long, max 10 allowed') if "#{@bank_account_number}".length > 10
      raise ArgumentError.new('Bank number too long, max 8 allowed') if "#{@bank_number}".length > 8
      raise ArgumentError.new('Client number too long, max 10 allowed') if "#{@client_number}".length > 10
      raise ArgumentError.new("Bank account number cannot be 0")  if @bank_account_number == 0
      raise ArgumentError.new("Bank number cannot be 0")   if @bank_number == 0
      raise ArgumentError.new("Street too long, max 35 allowed") if @street && @street.length > 35
      raise ArgumentError.new("City too long, max 35 allowed") if @city && @city.length > 35
      raise ArgumentError.new("Zip-Code too long, max 35 allowed") if @zip_code && @zip_code.length > 35
      raise ArgumentError.new("Bank Name too long, max 35 allowed") if @bank_name && @bank_name.length > 35
      raise ArgumentError.new("Sender Street too long, max 35 allowed") if @sender_street && @sender_street.length > 35
      raise ArgumentError.new("Sender City too long, max 35 allowed") if @sender_city && @sender_city.length > 35
      raise ArgumentError.new("Sender Zip-Code too long, max 35 allowed") if @sender_zip_code && @sender_zip_code.length > 35

    end

  end
end
