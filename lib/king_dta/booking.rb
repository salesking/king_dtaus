module KingDta
	class Booking
    include KingDta::Helper
    
    # Die am häufigsten benötigten Textschlüssel
    LASTSCHRIFT_ABBUCHUNG            = '04000'
    LASTSCHRIFT_EINZUGSERMAECHTIGUNG = '05000'
    UEBERWEISUNG_GUTSCHRIFT          = '51000'

    attr_reader :value, :account, :text, :schluessel
		#Eine Buchung ist definiert durch:
		#- Konto (siehe Klasse Konto
		#- Betrag
		#	Der Betrag kann , oder . als Dezimaltrenner enthalten.
		#- optional Buchungstext
		def initialize( account, value, text=nil, schluessel=nil )
      raise "Hey, a booking should have an Account" unless account.kind_of?( Account )
			@account = account
			@text = text ? convert_text( text ) : text
			@schluessel = schluessel
			if value.is_a?(String)
				value = BigDecimal.new value.sub(',', '.')
			elsif value.is_a?(Numeric)
			  value = BigDecimal.new value.to_s
			else
				raise "Gimme a value as a String or Numeric. You gave me a #{value.class}"
			end
			value = ( value * 100 ).to_i	#€-Cent
			if value == 0
				raise "A booking of 0.00 € makes no sence"
			elsif value > 0
				@value = value
				@pos	 = true
			else
				@value = -value
				@pos	 = false
			end
		end
    
    def text=(text)
       @text = convert_text( text )
    end

		def pos?; @pos end

	end	#class Buchung
end	#module dtaus
