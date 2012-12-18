# encoding: utf-8

module KingDta
  class DtazvBooking < Booking
    attr_accessor :customer_bill_text

    def initialize( account, value, text=nil, account_key=nil )
      super(account, value, text, account_key)
      raise Exception.new("The length of your text is too long. It must be at most 140 chars long.") if t.length > 140
    end

    def text=(text)
      raise Exception.new("The length of your text is too long. It must be at most 140 chars long.") if t.length > 140
      @text = text
    end

    def customer_bill_text=(text)
      raise Exception.new("The length of your text is too long. It must be at most 27 chars long.") if text.length > 27
      @customer_bill_text = convert_text(text)
    end
  end
end
