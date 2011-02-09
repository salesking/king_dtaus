# encoding: utf-8
module KingDta
  #Kontodaten verwalten mit Name des Inhabers und Bank, Bankleitzahl und Kontonummer.
  class Account
    include KingDta::Helper
    # dta~ jeweilige Feld in DTAUS-Norm
    attr_reader  :bank_account_number, :bank_number, :owner, :kunnr, :dtakunnr
    
    def initialize( ban, bank_number, owner, kunnr="" )
      @bank_account_number = ban.kind_of?( Integer ) ? ban : ban.gsub(/\s/, '').to_i
      @bank_number  = bank_number.kind_of?( Integer ) ? bank_number :  bank_number.gsub(/\s/, '').to_i
      @owner= convert_text( owner )
      @kunnr  = kunnr.gsub(/\s/, '').to_i
      
      raise KingDta::Exception.new("Invalid bank account number #{ban}")  if @bank_account_number == 0
      raise KingDta::Exception.new("BLZnummer #{bank_number} ungültig")   if @bank_number == 0
      raise KingDta::Exception.new("Invalid account owner #{owner}")      unless @owner.kind_of?(String) # not possible
      # @dtakunnr  = convert_text( @kunnr )
    end
    
  end
end
