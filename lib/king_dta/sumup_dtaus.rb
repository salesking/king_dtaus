# encoding: utf-8
module KingDta
  class SumupDtaus < Dtaus
    def add_c( booking )
      zahlungsart = if @typ == 'LK'
                      booking.account_key || Booking::LASTSCHRIFT_EINZUGSERMAECHTIGUNG
                    elsif @typ == 'GK'
                      booking.account_key || Booking::UEBERWEISUNG_GUTSCHRIFT
                    end
      #Extended segments Long name & booking texts
      # 1. Part
      #data1 = '%4i' % ?? #Satzlänge kommt später
      data1 = '0216' 
      data1 += 'C'
      data1 +=  '%08i' % 0
      data1 +=  '%-08i' % booking.account.bank_number
      data1 +=  '%010i' % booking.account.bank_account_number
      data1 +=  '0%011i0' % (booking.account.owner_number || 0)   #interne Kundennummer
      data1 +=  zahlungsart
      data1 +=  ' '
      data1 +=  '0' * 11
      data1 +=  '%08i' % @account.bank_number
      data1 +=  '%010i' % @account.bank_account_number
      data1 +=  '%011i' % booking.value #Betrag in Euro einschl. Nachkomma
      data1 +=  ' ' * 3
      data1 +=  '%-27.27s' % booking.account.owner_name
      data1 +=  ' ' * 8
      #Einfügen erst möglich, wenn Satzlänge bekannt

      # 2. Part
      data2 = "%-27.27s" % @account.owner_name
      #Erste 27 Zeichen
      #if text < 26  fill with spaces
      data2 += !booking.text.nil? ? booking.text[0].ljust(27) : default_text[0..26].ljust(27) # Just take the first 27 chars of the default text for now.
      data2 +=  '1' #EUR
      data2 +=  ' ' * 2
      # cut text into 27 long pieces
      data2 += '01' # Number of extensions
      data2 += '02'
      data2 += !booking.text.nil? ? booking.text[1].ljust(27) : default_text[27..53].to_s.ljust(27) 
      data2 +=  ' ' * 2
      data2 +=  ' ' * 27
      data2 +=  ' ' * 11

      # Gesamte Satzlänge ermitteln ( data1(+4) + data2 + Erweiterungen )
      raise "DTAUS: Längenfehler C/1 #{data1.size} nicht 128, #{booking.account.owner_name}" unless data1.size == 128
      dta_string << data1
            # add the final piece of the second C section
      raise "DTAUS: Längenfehler C/2 #{data2.size} nicht 128, #{booking.account.owner_name}" unless data2.size == 128
      dta_string << data2
      dta_string
    end  #dataC
  end
end
