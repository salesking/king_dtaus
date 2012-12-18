# encoding: utf-8

module KingDta
  class SumupBooking < Booking
    attr_accessor :customer_bill_text

    def initialize( account, value, text=[], account_key=nil )
      raise Exception.new("Hey, a booking should have an Account") unless account.kind_of?( Account )
      @account = account
      @text = text.each{ |t| 
        raise Exception.new("The length of your text is too long. It must be at most 27 chars long.") if t.size > 128
        convert_text(t)
      }
      @account_key = account_key
      if value.is_a?(String)
        value = BigDecimal.new value.sub(',', '.')
      elsif value.is_a?(Numeric)
        value = BigDecimal.new value.to_s
      else
        raise Exception.new("Gimme a value as a String or Numeric. You gave me a #{value.class}")
      end
      value = ( value * 100 ).to_i  #€-Cent
      if value == 0
        raise Exception.new("A booking of 0.00 € makes no sence")
      elsif value > 0
        @value = value
        @pos   = true
      else
        @value = -value
        @pos   = false
      end
    end

    def text=(text)
       @text = text.each { |t| 
         # TODO: Add some configuration because this should be specific to DTAUS but it is taken into consideration for DTAZV
         raise Exception.new("The length of your text is too long. It must be at most 27 chars long.") if t.size > 128
         convert_text( t ) 
       }
    end

    def customer_bill_text=(text)
      # TODO This is specific for DTAZV should be really...........
      raise Exception.new("The length of your text is too long. It must be at most 27 chars long.") if text.length > 27
      @customer_bill_text = convert_text(text)
    end
  end
end
