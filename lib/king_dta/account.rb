# encoding: utf-8
module KingDta
  #Kontodaten verwalten mit Name des Inhabers und Bank, Bankleitzahl und Kontonummer.
  class Account
    include KingDta::Helper
    # dta~ jeweilige Feld in DTAUS-Norm
    attr_reader  :bank_account_number, :bank_number, :owner, :client_number
    
    def initialize( ban, bank_number, owner, client_number="" )

      @bank_account_number = ban.kind_of?( Integer ) ? ban : ban.gsub(/\s/, '').to_i      
      @bank_number  = bank_number.kind_of?( Integer ) ? bank_number :  bank_number.gsub(/\s/, '').to_i      
      @client_number = client_number.kind_of?( Integer ) ? client_number : client_number.gsub(/\s/, '').to_i
      @owner= convert_text( owner )

      raise ArgumentError.new('Bank account number too long, max 10 allowed') if "#{@bank_account_number}".length > 10
      raise ArgumentError.new('Bank number too long, max 8 allowed') if "#{@bank_number}".length > 8
      raise ArgumentError.new('Client number too long, max 10 allowed') if "#{@client_number}".length > 10
      raise ArgumentError.new("Bank account number cannot be 0")  if @bank_account_number == 0
      raise ArgumentError.new("Bank number cannot be 0")   if @bank_number == 0
    end
    
  end
end
