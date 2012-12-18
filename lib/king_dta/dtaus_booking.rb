# encoding: utf-8

module KingDta
  class DtausBooking < Booking

    def initialize( account, value, text=[], account_key=nil )
      super(account, value, text, account_key)

      #@text = text.each{ |t| 
      #  raise Exception.new("The length of your text is too long. It must be at most 27 chars long.") if t.size > 128
      #  convert_text(t)
      #}
    end

    def text=(text)
       @text = text.each { |t| 
         # TODO: Add some configuration because this should be specific to DTAUS but it is taken into consideration for DTAZV
         raise Exception.new("The length of your text is too long. It must be at most 27 chars long.") if t.size > 128
         convert_text( t ) 
       }
    end

  end
end

