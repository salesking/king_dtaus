# encoding: utf-8

module KingDta
  class DtausBooking < Booking

    def initialize( account, value, account_key=nil )
      super(account, value, nil, account_key)
    end

    def text=(text)
      raise Exception.new("The text parameter must be passed as an array") if !text.kind_of?(Array)
      
      @text = text.each{ |t| 
        raise Exception.new("The length of your text is too long. It must be at most 27 chars long.") if t.size > 27
        convert_text(t)
      }
    end

  end
end

