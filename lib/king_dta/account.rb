# encoding: utf-8
module KingDta
  # A bank account with name of the account owner,
  # Kontodaten verwalten mit Name des Inhabers und Bank, Bankleitzahl und Kontonummer.
  class Account
    include KingDta::Helper
    
    attr_accessor :bank_account_number, :bank_number, :bank_street, :bank_city,
                  :bank_zip_code, :bank_name, :bank_country_code, :bank_iban,
                  :bank_bic,
                  :owner_name, :owner_number, :owner_street, :owner_city,
                  :owner_zip_code, :owner_country_code

    # TODO test
    def initialize(args={})

      @bank_street = convert_text(args.delete(:bank_street))
      @bank_city = convert_text(args.delete(:bank_city))
      @bank_name = convert_text(args.delete(:bank_name))
      @owner_name = convert_text(args.delete(:owner_name))
      @owner_street = convert_text(args.delete(:owner_street))
      @owner_city = convert_text(args.delete(:owner_city))

      args.each do |key,value|
        self.send("#{key}=",value)
      end

      raise ArgumentError.new('Bank number too long, max 11 allowed') if @bank_number && "#{@bank_number}".length > 11
      raise ArgumentError.new('Client number too long, max 10 allowed') if @owner_number && "#{@owner_number}".length > 10
      raise ArgumentError.new("Client Street too long, max 35 allowed") if @owner_street && @owner_street.length > 35
      raise ArgumentError.new("Client City too long, max 35 allowed") if @owner_city && @owner_city.length > 35
      raise ArgumentError.new("Client Country code too long, max 2 allowed") if @owner_country_code && @owner_country_code.length > 2

      raise ArgumentError.new('Bank account number too long, max 35 allowed') if @bank_account_number && "#{@bank_account_number}".length > 35
      raise ArgumentError.new("Bank account number cannot be 0")  if @bank_account_number && @bank_account_number == 0
      raise ArgumentError.new("Bank number cannot be 0")   if @bank_number && @bank_number == 0
      raise ArgumentError.new("Bank Street too long, max 35 allowed") if @bank_street && @bank_street.length > 35
      raise ArgumentError.new("Bank City too long, max 35 allowed") if @bank_city && @bank_city.length > 35
      raise ArgumentError.new("Bank Name too long, max 35 allowed") if @bank_name && @bank_name.length > 35
      raise ArgumentError.new("Bank Country code too long, max 2 allowed") if @bank_country_code && @bank_country_code.length > 2

    end

    def zip_city
      "#{@bank_zip_code} #{@bank_city}"
    end

    def owner_zip_city
      "#{@owner_zip_code} #{@owner_city}"
    end

  end
end
