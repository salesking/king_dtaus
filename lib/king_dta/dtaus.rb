# encoding: utf-8
module KingDta
  #Create a DTAUS string.
  # == infos
  # https://www.ksk-koeln.de/formatbeschreibung_datentraegeraustausch.pdfx
  # http://www.infodrom.org/projects/dtaus/dtaus.html
  class Dtaus < KingDta::Dta
    attr_reader :sum_bank_account_numbers, :sum_bank_numbers, :sum_values

    # Create a new dtaus file/string.
    # === Parameter
    # typ<String>:: valid strings are 'LK' (Lastschrift Kunde) and 'GK' (Gutschrift Kunde)
    # typ<Date>:: date when the the transfer is to be created
    def initialize( typ, date=Date.today )
      raise ArgumentError.new("Unknown order type: #{typ}. Allowed Values are LK, GK") unless ['LK','GK'].include?(typ)
      @typ = typ
      super(date)
    end

    # Creates the whole dta string(in the right order) and returns it
    # === Raises
    # error if there are no bookings
    def create
      raise Exception.new("Cannot create DTAUS without bookings") if bookings.empty?
      @closed = true
      # cleanup before we start
      @dta_string = dta_string.empty? ? dta_string : ''
      set_checksums
      add_a
      bookings.each{ |b| add_c( b) }
      add_e
      dta_string
    end

    # TODO do it works? the .to_i stuff
    def set_checksums
      @sum_bank_account_numbers, @sum_bank_numbers, @sum_values  = 0,0,0
      bookings.each do |b|
        @sum_bank_account_numbers  += b.account.bank_account_number.to_i
        @sum_bank_numbers += b.account.bank_number.to_i
        @sum_values += b.value
      end
    end

    #Erstellen A-Segment der DTAUS-Datei
    #Aufbau des Segments:
    # Nr. Start Länge  Beschreibung
    # 1   0      4     Länge des Datensatzes, immer 128 Bytes, also immer "0128"
    # 2   4      1     Datensatz-Typ, immer 'A'
    # 3   5      2     Art der Transaktionen
    #                  "LB" für Lastschriften Bankseitig
    #                  "LK" für Lastschriften Kundenseitig
    #                  "GB" für Gutschriften Bankseitig
    #                  "GK" für Gutschriften Kundenseitig
    # 4   7     8      Bankleitzahl des Auftraggebers
    # 5   15    8      CST, "00000000", nur belegt, wenn Diskettenabsender Kreditinstitut
    # 6   23    27     Name des Auftraggebers
    # 7   50    6      aktuelles Datum im Format DDMMJJ
    # 8   56    4      CST, "    " (Blanks)
    # 9   60    10     Kontonummer des Auftraggebers
    # 10  70    10     Optionale Referenznummer
    # 11a 80    15     Reserviert, 15 Blanks
    # 11b 95    8      Ausführungsdatum Format DDMMJJJJ. max A7 + 15 Tage. Default Blanks.
    # 11c 103   24     Reserviert, 24 Blanks
    # 12  127   1      Währungskennzeichen  "1" = Euro
    #                  
    #    Insgesamt 128 Zeichen
    def add_a
      data = '0128'
      data += 'A'
      data += @typ
      data += '%8i' % @account.bank_number #.rjust(8)
      data += '%08i' % 0
      data += '%-27.27s' % @account.owner_name
      data += @date.strftime("%d%m%y")              # creation date - today
      data += ' ' * 4
      data += '%010i' % @account.bank_account_number.to_i
      data += '%010i' % 0
      data += ' '  * 15
      data += '%8s' % @date.strftime("%d%m%Y")     #Ausführungsdatum - ja hier 8 Stellen
      data += ' ' * 24
      data += '1'
      raise "DTAUS: Längenfehler A (#{data.size} <> 128)\n" if data.size != 128
      dta_string << data
    end #dataA

    #Erstellen C-Segmente (Buchungen mit Texten) der DTAUS-Datei
    #Aufbau:
    #  Nr. St  Länge  Beschreibung
    #  1   0    4     Länge des Datensatzes, 187 + x * 29 (x..Anzahl Erweiterungsteile)
    #  2   4    1     Datensatz-Typ, immer 'C'
    #  3   5    8     Bankleitzahl des Auftraggebers (optional)
    #  4   13   8     Bankleitzahl des Kunden
    #  5   21   10    Kontonummer des Kunden
    #  6   31   13    Verschiedenes
    #                 1. Zeichen: "0"
    #                 2. - 12. Zeichen: interne Kundennummer oder Nullen
    #                 13. Zeichen: "0"
    #                 Die interne Nummer wird vom erstbeauftragten Institut zum endbegünstigten Institut weitergeleitet.
    #                 Die Weitergabe der internenen Nummer an den Überweisungsempfänger ist der Zahlstelle freigestellt.
    #  7   44  5    Art der Transaktion (7a: 2 Zeichen, 7b: 3 Zeichen)
    #               "04000" Lastschrift des Abbuchungsauftragsverfahren
    #               "05000" Lastschrift des Einzugsermächtigungsverfahren
    #               "05005" Lastschrift aus Verfügung im elektronischen Cash-System
    #               "05006" Wie 05005 mit ausländischen Karten
    #               "51000" Überweisungs-Gutschrift
    #               "53000" Überweisung Lohn/Gehalt/Rente
    #               "5400J" Vermögenswirksame Leistung (VL) ohne Sparzulage
    #               "5400J" Vermögenswirksame Leistung (VL) mit Sparzulage
    #               "56000" Überweisung öffentlicher Kassen
    #               Die im Textschlüssel mit J bezeichnete Stelle, wird bei Übernahme
    #               in eine Zahlung automatisch mit der jeweils aktuellen Jahresendziffer (7, wenn 97) ersetzt.
    #  8   49  1    Reserviert, " " (Blank)
    #  9   50  11   Betrag in DM
    #  10  61  8    Bankleitzahl des Auftraggebers
    #  11  69  10   Kontonummer des Auftraggebers
    #  12  79  11   Betrag in Euro einschließlich Nachkommastellen
    #  13  90  3    Reserviert, 3 Blanks
    #  14a 93  27   Name des Kunden
    #  14b 120 8    Reserviert, 8 Blanks
    #    Insgesamt 128 Zeichen
    #
    #  15  128  27  Name des Auftraggebers
    #  16  155  27  Verwendungszweck
    #  17a 182  1   Währungskennzeichen  "1" = Euro
    #  17b 183  2   Reserviert, 2 Blanks
    #  18  185  2   Anzahl der Erweiterungsdatensätze, "00" bis "15"
    #  19  187  2   Typ (1. Erweiterungsdatensatz)
    #               "01" Name des Kunden
    #               "02" Verwendungszweck
    #               "03" Name des Auftraggebers
    #  20  189  27  Beschreibung gemäß Typ
    #  21  216  2   wie C19, oder Blanks (2. Erweiterungsdatensatz)
    #  22  218  27  wie C20, oder Blanks
    #  23  245  11  Blanks
    #  Insgesamt 256 Zeichen, kann wiederholt werden (max 3 mal)
    #
    # === Parameter
    # booking<Object>::Booking object to be written to c-section
    #
    # === Returns
    # <String>:: The current dta_string
    def add_c( booking )
      zahlungsart = if @typ == 'LK'
                      booking.account_key || Booking::LASTSCHRIFT_EINZUGSERMAECHTIGUNG
                    elsif @typ == 'GK'
                      booking.account_key || Booking::UEBERWEISUNG_GUTSCHRIFT
                    end
      #Extended segments Long name & booking texts
      exts = []
      # 1. Part
      #data1 = '%4i' % ?? #Satzlänge kommt später
      data1 = 'C'
      data1 +=  '%08i' % 0
      data1 +=  '%-08i' % booking.account.bank_number
      data1 +=  '%010i' % booking.account.bank_account_number.to_i
      data1 +=  '0%011i0' % (booking.account.owner_number || 0)   #interne Kundennummer
      data1 +=  zahlungsart
      data1 +=  ' '
      data1 +=  '0' * 11
      data1 +=  '%08i' % @account.bank_number
      data1 +=  '%010i' % @account.bank_account_number.to_i
      data1 +=  '%011i' % booking.value #Betrag in Euro einschl. Nachkomma
      data1 +=  ' ' * 3
      data1 +=  '%-27.27s' % booking.account.owner_name
      exts << ['01', booking.account.owner_name[27..999] ] if booking.account.owner_name.size > 27
      data1 +=  ' ' * 8
      #Einfügen erst möglich, wenn Satzlänge bekannt

      # 2. Part
      data2 = "%27.27s" % @account.owner_name
      booking_txt = booking.text || default_text
      #Erste 27 Zeichen
      #if text < 26  fill with spaces
      data2 +=  booking_txt[0..26].ljust(27)
      booking_txt = booking_txt[27..999]
      # cut text into 27 long pieces
      while booking_txt && booking_txt.size > 0 && exts.size < 13
        exts << ['02', booking_txt.ljust(27) ]
        booking_txt = booking_txt[27..999]
      end
      exts << ['03', @account.owner_name[27..999] ] if @account.owner_name.size > 27

      data2 +=  '1' #EUR
      data2 +=  ' ' * 2
      # Gesamte Satzlänge ermitteln ( data1(+4) + data2 + Erweiterungen )
      data1 = "%04i#{data1}" % ( data1.size + 4 + data2.size+ 2 + exts.size * 29 )
      raise "DTAUS: Längenfehler C/1 #{data1.size} nicht 128, #{booking.account.owner_name}" unless data1.size == 128
      dta_string << data1
      #Anzahl Erweiterungen anfügen
      data2 +=  '%02i' % exts.size  #Anzahl Erweiterungsteile
      #Die ersten zwei Erweiterungen gehen in data2,
      #Satz 3/4/5 à 4 Erweiterungen  -> max. 14 Erweiterungen (ich ignoriere möglichen Satz 6)
      exts  += [ ['00', "" ]  ] * (14 - exts.size)
      #Die ersten zwei Erweiterungen gehen in data2,  wenn leer nur mit blanks als füllung
      exts[0..1].each{|e| data2 +=  "%2.2s%-27.27s" % format_ext(e[0], e[1]) }
      data2 +=  ' ' * 11
      # add the final piece of the second C section
      raise "DTAUS: Längenfehler C/2 #{data2.size} nicht 128, #{booking.account.owner_name}" unless data2.size == 128
      dta_string << data2
      #Create 4 text extensions
      add_ext( exts[2..5] )
      add_ext( exts[6..9] )
      add_ext( exts[10..13] )
      dta_string
    end  #dataC

    # Format an extension so it can be used in string substitution
    # === Returns
    # Array[String, String]::[Extesnsion type(01 02 03), 'text content ..']
    def format_ext(type, content)
      ext = ( type == '00' ) ? [' ', ' '] : [ type, convert_text(content) ]
      ext
    end

    # Add a section-C extension, always containing the section type followed by
    # 4 segments with 27 chars and an ending seperator of 12 blanks
    # Only adds the segement if something is in there
    # === Parameter
    # <Array[Array[String,String]]>:: two dim. ary containing: [extension type(01 02 03),string content]
    def add_ext( ext)
      raise "Nur #{ext.size} Erweiterungstexte, 4 benötigt" if ext.size != 4
      str =  "%2.2s%-27.27s" % format_ext(ext[0][0], ext[0][1] )
      str +=  "%2.2s%-27.27s" % format_ext( ext[1][0], ext[1][1] )
      str +=  "%2.2s%-27.27s" % format_ext( ext[2][0], ext[2][1] )
      str +=  "%2.2s%-27.27s" % format_ext( ext[3][0], ext[3][1] )
      # devider 12 blanks
      str += ' ' * 12
      unless  str !~ /\S/ # only add if something is in there .. only whitespace => same as str.blank?
        raise "DTAUS: Längenfehler C/3 #{str.size} " if str.size != 128
        dta_string << str
      end
    end  #dataC

    #Erstellen E-Segment (Prüfsummen) der DTAUS-Datei
    #Aufbau:
    #  Nr. Start Länge   Beschreibung
    #  1   0    4     Länge des Datensatzes, immer 128 Bytes, also immer "0128"
    #  2   4    1     Datensatz-Typ, immer 'E'
    #  3   5    5     "     " (Blanks)
    #  4   10   7    Anzahl der Datensätze vom Typ C
    #  5   17   13   Kontrollsumme Beträge
    #  6   30   17   Kontrollsumme Kontonummern
    #  7   47   17   Kontrollsumme Bankleitzahlen
    #  8   64   13   Kontrollsumme Euro
    #  9   77   51   Blanks
    #  Insgesamt 128 Zeichen
    def add_e
      str = '0128'
      str += 'E'
      str += ' ' * 5
      str += '%07i' % @bookings.size
      str += '0' * 13
      str += '%017i' % @sum_bank_account_numbers
      str += '%017i' % @sum_bank_numbers
      str += '%013i' % @sum_values
      str += ' '  * 51
      raise "DTAUS: Längenfehler E #{str.size} <> 128" if str.size != 128
      dta_string << str
    end

  end  #class dtaus
end
