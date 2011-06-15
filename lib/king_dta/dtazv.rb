# encoding: utf-8
module KingDta
  class Dtazv < Dta

    # Create a new dtazv file/string.
    # ===Parameter
    # typ<Date>:: date when the the transfer is to be created
    def initialize(date=Date.today)
      raise ArgumentError.new("Wrong date format. Make it a Time or Date object with yyyy-mm-dd") unless date.respond_to?(:strftime)
      @date = date
      @value_pos  = true  #all values are positive by default. Variable changes with first booking entry
      @closed     = false
      @default_text = 'Want some? Come, get some!' # default verwendungzweck
    end

    # Creates the whole dta string(in the right order) and returns it
    # === Raises
    # error if there are no bookings
    def create
      raise Exception.new("Cannot create DTAUS without bookings") if bookings.empty?
      @closed = true
      # cleanup before we start
      @dta_string = dta_string.empty? ? dta_string : ''
      add_q
      bookings.each{ |b| add_t(b) }
      add_z(bookings)
    end

    #Erstellen P-Segment der DTAZV-Datei
    # - P Datei-Vorsatz mit 256 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    # Aufbau und Erläuterungen der Datei
    # Datensatz P (Datei-Vorsatz)

    # Der Vorsatz enthält Informationen über ein Institut, das Kundendatensätze Q, T, V und W als Meldung
    # nach §§ 59 ff. der AWV weiterleitet. Der Vorsatz bezieht sich auf alle unmittelbar folgen­ den
    # Kundendatensätze, deren Folge mit einem Datei-Nachsatz Y abgeschlossen wird.

    # Legende:
    # K = Kannfeld
    # P = Pflichtfeld
    # K/P = Pflichtfeld in Abhängigkeit von bestimmten Kriterien
    # N = nicht belegbares Feld
    # alpha = alphanumerische Daten (linksbündig, nicht belegte Stellen: Leerzeichen)
    # num = numerische Daten (rechtsbündig, nicht belegte Stellen Nullen)

    # Feld  Länge in Bytes  1. Stelle im Satz Feldart Datenformat Inhalt            Erläuterungen
    # 1     4               1                 P       binär/num   Satzlänge         Längenangabe des Satzes nach den Konventionen für variable Satzlänge (binär bei Bändern 3, numerisch bei Disketten und DFÜ)
    # 2     1               5                 P       alpha       Satzart           Konstante 'P'
    # 3     8               6                 K/P     num         Bankleitzahl      BLZ des Einreichinstituts
    # 4     4x35            14                P       alpha       Einreichinstitut  Zeile 1 u. 2: Name; Zeile 3: Straße Postfach; Zeile 4: Ort
    # 5     6               154               P       num         Erstellungsdatum  In der Form JJMMTT
    # 6     2               160               P       num         laufende Nummer   Laufende Tagesnummer
    # 7     95              162               N       alpha                         Reserve
    def add_p
      # data  = '0256'                                    # Länge des Datensatzes, PFLICHT
      # data += 'P'                                       # Satzart, PFLICHT
      # data += '%8i'   %  @account.bank_number           # BLZ des Einreichinstituts, KANN
      # data += '%70s'  %  @account.bank_name             # Einreichinstitut  Zeile 1 u. 2: Name; PFLICHT
      # data += '%35s'  %  @account.account_street_zip    # Einreichinstitut Straße Postfach; Ort PFLICHT
      # data += '%35s'  %  @account.city                  # Einreichinstitut  Zeile 4: Ort PFLICHT
      # data += @date.strftime("%y%m%d")                  # Erstellungsdatum  In der Form JJMMTT, PFLICHT
      # data += '01'                                      # laufende Nummer Laufende Tagesnummer, PFLICHT
      # data += '%095s' % ''                               # Reserve
      # raise "DTAUS: Längenfehler P (#{data.size} <> 256)\n" if data.size != 256
      # dta_string << data
    end

    #Erstellen Q-Segment der DTAZV-Datei
    # - Q Auftraggebersatz mit 256 oder 246 Bytes (= Datei-Vorsatz aus dem Datenaustausch zwischen Kunde und Bank)
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string

    # 5.2	Datensatz Q - lange Variante - (Identifikation des Auftraggebers)
    # Die Bundesbank nimmt Q-Sätze in 2 Varianten entgegen. Die lange Variante ist identisch mit den von
    # den Auftraggebern gelieferten Q-Sätzen. In der kurzen Variante sind nur die Felder enthalten,
    # die von der Bundesbank bei der Bearbeitung der Meldungen benötigt werden (siehe 5.3).
    # Beide Varianten dürfen in einer Datei vorkommen.

    # Datensatz Q - kurze Variante
    # Die Bundesbank nimmt Q-Sätze in 2 Varianten entgegen. Die lange Variante ist identisch mit
    # den von den Auftraggebern gelieferten Q-Sätzen. In der kurzen Variante sind nur die Felder
    # enthalten, die von der Bundesbank bei der Bearbeitung der Meldungen benötigt werden; das in der
    # kurzen Variante nicht enthaltene Feld ist in der folgenden Tabelle durch Schattierung und Kursivschrift
    # kenntlich gemacht. Beide Varianten dürfen in einer Datei vorkommen.

    # [ Anmerk.: Bei der Kurzen Variante entfällt die Kundennummer ]

    # Feld  Länge in Bytes  1. Stelle im Satz Feldart Datenformat Inhalt                                Erläuterungen
    # 1     4               1                 P       binär/num   Satzlänge                             Längenangabe des Satzes nach den Konventionen für variable Satzlänge (binär bei Bändern, numerisch bei Disketten und DFÜ)
    # 2     1               5                 P       alpha       Satzart                               Konstante "Q"
    # 3     8               6                 P       num         BLZ                                   Erstbeauftragtes Kreditinstitut
    # Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN --------------------------------------------------------------------------------------------------------
    # 4     10              14                P       num         Kundennummer                          Ordnungsnummer gemäß Vereinbarung mit dem erstbeauftragten Kreditinstitut (ggf. Kontonummer)
    # /Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 5     4x35            24                P       alpha       Auftraggeberdaten                     Zeile 1 und 2: Name; Zeile 3: Straße / Postfach; Zeile 4: Ort
    # 6     6               164               P       num         Erstellungsdatum                      Format: JJMMTT
    # 7     2               170               P       num         laufende Nummer                       Laufende Tagesnummer
    # 8     6               172               P       num         (erster) Ausführungstermin Datei      Format: JJMMTT; gleich oder bis zu höchstens 15 Kalendertage nach dem Datum aus Feld Q6
    # 9     1               178               P       alpha       Weiterleitung an die Meldebehörde     Soll das erstbeauftragte Kreditinstitut Meldedaten zu den nachfolgenden Zahlungen an die Bundesbank weiterleiten ? (siehe Erläuterungen im Anhang 3). 'J'	Ja 'N'	Nein
    # 10    2               179               K/P     num         Bundeslandschlüssel                   Zwingend belegt, wenn Meldedaten zu den Zahlungen an die Bundesbank weitergeleitet wer­ den sollen. ('J' in Feld Q9)
    # 11    8               181               K/P     num         Firmennummer / BLZ des Auftraggebers  Siehe Erläuterungen Feld Q10
    # 12    68              189               N       alpha                                             Reserve
    def add_q
      data1  = '0256'                                  # Länge des Datensatzes, PFLICHT
      data1 += 'Q'                                     # Satzart, PFLICHT
      data1 += '%08i'   %  @account.bank_number        # BLZ des Einreichinstituts, PFLICHT
      data1 += '%010i'  %  @account.account_number     # Kundennummer, PFLICHT
      data1 += '%-035s'  %  @account.client_firstname        # Einreichinstitut  Zeile 1 u. 2: Name, PFLICHT
      data1 += '%-035s'  %  @account.client_surname        # Einreichinstitut  Zeile 1 u. 2: Name, PFLICHT
      data1 += '%-035s'  %  @account.client_street  # Einreichinstitut  Zeile 3: Straße Postfach, PFLICHT
      data1 += '%-035s'  %  @account.client_zip_city        # Einreichinstitut  Zeile 4: Ort, PFLICHT
      data1 += @date.strftime("%y%m%d")                # Erstellungsdatum  In der Form JJMMTT, PFLICHT
      data1 += '01'                                    # laufende Nummer   Laufende Tagesnummer, PFLICHT
      data1 += @date.strftime("%y%m%d")                # (erster) Ausführungstermin Datei, PFLICHT
      data1 += "N"                                     # Weiterleitung an die Meldebehörde, PFLICHT
      data1 += "%02i"    % 0                           # Bundeslandschlüssel, KANN, NICHT BELEGT, KEINE MELDUNG
      data1 += '%08i'    % 0                           # @account.bank_number # Firmennummer / BLZ des Auftraggebers, KANN, NICHT BELEGT, KEINE MELDUNG
      data1 += '%068s'   % ''                           # Reserve
      raise "DTAUS: Längenfehler Q (#{data.size} <> 256)\n" if data1.size != 256
      dta_string << data1
    end

    #Erstellen T-Segment der DTAZV-Datei
    # - T Einzelzahlungssatz mit 768 oder 572 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string

    # 5.4	Datensatz T - lange Variante - (Einzelzahlungssatz)
    # Die Bundesbank nimmt auch T-Sätze in 2 Varianten entgegen. Die lange Variante ist identisch
    # mit den von den Auftraggebern gelieferten T-Sätzen. In der kurzen Variante sind
    # nur die Felder enthalten, die von der Bundesbank bei der Bearbeitung der Meldungen
    # benötigt werden (siehe 5.5). Beide Varianten dürfen in einer Datei vorkommen.

    # 5.5	Datensatz T - kurze Variante
    # Die Bundesbank nimmt auch T-Sätze in 2 Varianten entgegen. Die lange Variante ist identisch
    # mit den von den Auftraggebern gelieferten T-Sätzen. In der kurzen Variante sind nur
    # die Felder enthalten, die von der Bundesbank bei der Bearbeitung der Meldungen benötigt
    # werden. Die in der kurzen Variante nicht enthaltenen Felder sind in der folgenden Tabelle
    # durch Schattierung und Kursivschrift kenntlich gemacht. Beide Varianten dürfen in einer Datei vorkommen.

    # Feld  Länge in Bytes  1. Stelle im Satz Datenformat       Inhalt                          Erläuterungen allg.                                 Feldart allg.   EU-Std.Ü. Feldart EU-Std.Ü. Besondere Belegungsvorschriften EUE-Ü. Feldart  EUE-Ü. Besondere Belegungsvorschriften
    # 1     4               1                 binär/num         Satzlänge                       Längenangabe des Satzes nach den Kon­ ventionen     P               P                 -                                         P               -
      #                                                                                         für variable Satzlänge (binär bei Bändern
    #                                                                                           numerisch bei Disketten und DFÜ)
    # 2     1               5                 alpha             Satzart                         Konstante "T"                                       P               P                 -                                         P               -
    # 3     8               6                 num               BLZ                             BLZ der kontoführenden Stelle des mit dem
    #                                                                                           Auftragswert zu belastenden Kontos (Feld T4b)       P               P                 -                                         P               -
    # Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 4a    3               14                alpha             ISO-Währungscode                Für mit Auftragswert zu belastendes Konto.          P               P                 Nur "EUR" zulälssig                       P               Nur "EUR" zulässig
    # 4b    10              17                num               Kontonummer                     Mit Auftragswert zu belastendes Konto               P               P                 -                                         P               -
    # /Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 5     6               27                num               Ausführungstermin               Format: JJMMTT; gleich oder nach dem Datum aus      K               K                 -                                         K               -
    #                                                           Einzelzahlung, wenn             Feld Q8, jedoch bis zu höchstens 15 Kalendertage
    #                                                           abweichend von Feld Q8          nach dem Datum aus Feld Q6; fehlt der Termin in
    #                                                                                           T5, so wird das Datum in Q8 als Ausführungstermin
    #                                                                                           angenommen.
    # Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 6     8               33                num               BLZ                             BLZ der kontoführenden Stelle des mit Entgelten     K/P             N                 -                                         K/P             -
    #                                                                                           und Auslagen zu belastenden Kontos. (belegt,
    #                                                                                           wenn dieses Konto abweicht von Auftragswertkonto)
    # 7a    3               41                alpha             ISO-Währungscode                Währungscode des mit Entgelten und Aus­ lagen zu    K/P             N                 -                                         K/P             Nur 'EUR' zulässig
    #                                                                                           belastenden Kontos. (belegt, wenn dieses Konto
    #                                                                                           abweicht von Auftragswertkonto)
    # 7b    10              44                num               Kontonummer                     Kontonummer des mit Entgelten und Auslagen zu       K/P             N                 -                                         K/P             Nur 'EUR' zulässig
    #                                                                                           belastenden Kontos. (belegt, wenn dieses Konto
    #                                                                                           abweicht von Auftragswertkonto)
    # /Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 8     11              54                alpha             Bank Identifier Code (BIC)      Sofern die Zahlung an einen deutschen
    #                                                           des Zahlungsdienstleisters      Zahlungsdienstleister erfolgt, alternativ auch      K/P             P                 Bank Identifier Code	P (BIC)             P               Bank Identifier Code (BIC) ist Pflicht.
    #                                                           des Zahlungsempfängers oder     die BLZ des Zahlungsdienstleisters des                                                ist Pflicht. Zahlungsdienstleister
    #                                                           sonstige Identifikation, z.B.   Zahlungsempfängers, wobei dieser drei                                                 des Zahlungsempfängers muss in
    #                                                           CHIPS-ID                        Schrägstriche voranzustellen sind.                                                    einem der Län­ der gemäß Anhang
    #                                                                                           (Nicht zu belegen bei Scheckziehungen,                                                4 ansässig sein.
    #                                                                                           d.h. bei den Zahlungsartschlüsseln
    #                                                                                           20-23 und 30-33 in Feld T22)
    # 9a    3               65                alpha             Ländercode für den              2-stelliger ISO-alpha-Ländercode gemäß
    #                                                           Zahlungsdienstleister des       Länderverzeichnis für die Zahlungsbilanzstatistik;  K/P             N                 -                                         N               -
    #                                                           Zahlungsempfängers              linksbündig zu belegen; 3. Stelle Leerzeichen
    #                                                                                           (Pflichtfeld, wenn Feld T8 nicht belegt; nicht zu
    #                                                                                           belegen bei Scheckziehungen, d.h. bei den
    #                                                                                           Zahlungsartschlüsseln 20-23 und 30-33 in Feld T22)
    # 9b    4x35            68                alpha             Anschrift des                   Pflichtfeld, wenn Feld T8 nicht mit BIC- Adresse
    #                                                           Zahlungsdienstleisters          bzw. - bei Zahlungen an einen deutschen             K/P             N                 -                                         N               -
    #                                                           des Zahlungsempfängers          Zahlungsdienstleister - nicht mit BLZ belegt;
    #                                                                                           sofern Anschrift nicht bekannt, Konstante
    #                                                                                           „UNBEKANNT" Zeile 1 und 2: Name Zeile 3	:
    #                                                                                           Straße Zeile 4	: Ort (Nicht zu belegen
    #                                                                                           bei Scheckziehungen, d.h. bei den
    #                                                                                           Zahlungsartschlüsseln 20-23 und 30-33 in Feld T22)
    # 10a   3               208               alpha           Ländercode für Land des           2-stelliger ISO-alpha-Ländercode gemäß              P               P                 -                                         P
    #                                                         Zahlungsempfängers bzw.           Länderverzeichnis für die Zahlungsbilanzstatistik;
    #                                                         Scheckempfängers                  linksbündig zu belegen; 3. Stelle Leerzeichen
    # 10b   4x35            211               alpha           Zahlungsempfänger bzw.            Bei Zahlungsauftrag: Zahlungsempfänger Bei          P               P                 Angabe eines Scheckempfängers nicht       P               Angabe eines Scheck­ empfängers nicht möglich
    #                                                         Scheckempfänger                   Scheckziehung:	Scheckempfänger Zeile 1 und 2:                                        möglich
    #                                                                                           Name Zeile 3	: Straße Zeile 4	: Ort/Land.
    # Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 11    2x35            351               alpha           Ordervermerk                      Nur belegt bei Scheckziehung (d.h. bei den
    #                                                                                           Zahlungsartschlüsseln 20-23 und 30-33 in Feld T22)  K/P             N                 -                                         N               -
    #                                                                                           und Abweichung vom Inhalt der Zeilen 1 und 2
    #                                                                                           des Feldes T10b
    # 12    35              421               alpha           IBAN bzw. Kontonummer des         IBAN oder Kontonummer des Zahlungs­ empfängers,
    #                                                         Zahlungsempfängers                linksbündig, mit Schrägstrich beginnend.            K/P             P                 Nur IBAN zulässig;Linksbündig             P               Nur IBAN zulässig; Linksbündig, mit Schräg­ strich beginnend.
    #                                                                                           (Nicht zu belegen bei Scheckziehungen, d.h.                                           mit Schräg­ strich beginnend.
    #                                                                                           bei den Zahlungsartschlüsseln 20-23 und 30-33
    #                                                                                           in Feld T22)
    # /Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 13    3               456               alpha           Auftragswährung                   ISO-Code der zu zahlenden Währung                   P               P                 Nur 'EUR' zulässig                        P               Nur 'EUR' zulässig
    # 14a   14              459               num             Betrag (Vorkommastellen)          Rechtsbündig                                        P               P                 Nur Beträge bis max. 50k EUR zulässig     P               -
    # 14b   3               473               num             Betrag (Nachkommastellen)         Linksbündig                                         P               P                 -                                         P               -
    # 15    4x35            476               alpha           Verwendungszweck                  -                                                   K               K                 -                                         K               -
    # 16    2               616               num             Weisungsschlüssel 1               Nicht zu belegen bei Scheckziehungen,               K               N                 -                                         K               Nur Weisungsschlüssel ‚10‘, ‚11‘ und ‚12‘ aus Anhang 2 zulässig
    #                                                         (gem. Anhang 2)                   (d.h. bei den Zahlungsartschlüsseln 20-23
    #                                                                                           und 30-33 in Feld T22)
    # 17    2               618               num             Weisungsschlüssel 2               Nicht zu belegen bei Scheckziehungen,               K               N                 -                                         K               Nur Weisungsschlüssel ‚10‘, ‚11‘ und ‚12‘ aus Anhang 2 zulässig
    #                                                         (gem. Anhang 2)                   (d.h. bei den Zahlungsartschlüsseln
    #                                                                                           20-23 und 30-33 in Feld T22)
    # 18    2               620               num             Weisungsschlüssel 3               Nicht zu belegen bei Scheckziehungen,               K               N                 -                                         K               Nur Weisungsschlüssel ‚10‘, ‚11‘, und ‚12‘ aus Anhang 2 zulässig
    #                                                         (gem. Anhang 2)                   (d.h. bei den Zahlungsartschlüsseln
    #                                                                                           20-23 und 30-33 in Feld T22)
    # 19    2               622               num             Weisungsschlüssel 4               Mit	‘91‘	zu belegen im Falle von "Euro-
    #                                                         (gem. Anhang 2 und 2a)            Gegenwertzahlungen“ (vgl. Anhang 2a).               K/P             N                 -                                         K               Nur Weisungsschlüssel ‚10‘, ‚11‘ und ‚12‘ aus Anhang 2 zulässig
    #                                                                                           Bei Scheckziehungen, d.h. bei den
    #                                                                                           Zahlungsartschlüsseln 20-23 und 30-33
    #                                                                                           in Feld T22 nur '91' möglich.
    # Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 20    25              624               alpha           Zusatzinformationen zum           Z. B. Telex, Tel.-Nr., Kabelanschrift
    #                                                         Weisungsschlüssel                 (Nicht zu belegen bei Scheckziehungen,              K               N                 -                                         K               Nur bei Weisungs­ schlüssel ‚10‘ aus An­ hang 2 zulässig
    #                                                                                           d.h. bei den Zahlungsartschlüsseln 20-23
    #                                                                                           und 30-33 in Feld T22)
    # 21    2               649               num             Entgeltregelung                   00 = Entgelte zu Lasten Auftraggeber /              K/P             P                 Nur '00' zugelassen                       K/P             -
    #                                                                                             fremde Entgelte und Auslagen zu Lasten
    #                                                                                             Zahlungsempfänger
    #                                                                                           01 = alle Entgelte und Auslagen zu Lasten
    #                                                                                             Auftraggeber
    #                                                                                           02 = alle Entgelte und Auslagen zu Lasten
    #                                                                                            Zahlungsempfänger
    #                                                                                           (Bei Überweisungen im EWR in EWR- Währungen
    #                                                                                           ohne Währungsumrechnung – Feld T4a = Feld T13
    #                                                                                           – nur „00“ zulässig.)
    #                                                                                           (Bei Scheckziehung, d.h. bei Zahlungsartschlüssel
    #                                                                                           20-23 und 30-33 in Feld T22 nur ‚00‘ möglich)
    # 22  2                 651               num             Kennzeichnung der Zahlungsart     Gemäß Anhang 1; Zahlungen, die weder '11' noch      P               P                 Nur Zahlungsartschlüssel ‚13‘             P               Nur Zahlungsart­ schlüssel ‚11‘ aus Anhang 1 zulässig
    #                                                                                            '13' als Zahlungsartschlüssel enthalten, gelten                                      aus Anhang 1 zulässig
    #                                                                                            als allgemeine Zahlungen.
    # 23  27                653               alpha           Variabler Text nur für            Vom Auftraggeber frei belegbar
    #                                                          Auftraggeberabrechnung            (z.B. Refe­ renz-Nr.); wird nicht weitergeleitet;   K               K                 -                                         K               -
    #                                                                                            weiterzuleitende Informationen in Feld T15
    #                                                                                            angeben; maximal 16 Stellen werden in den
    #                                                                                            elektronischen Kontoauszug übernommen.
    #                                                                                            (nur nach Absprache mit dem Kreditinstitut)
    # /Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 24  35                680               alpha           Name und Telefonnummer sowie       Ansprechpartner beim Auftraggeber für eventuelle
    #                                                          ggf. Stellvertretungsmeldung      Rückfragen der beauftragten Bank oder der           K/P             K                 Ansprechpartner beim Auftraggeber         K/P             -
    #                                                                                            Meldebehörde. Dahinter, wenn Auftraggeber                                             für eventuelle Rückfragen der
    #                                                                                            nicht Zahlungspflichtiger ist:	‘INVF’,                                               beauftragten Bank
    #                                                                                            ohne Leerstellen gefolgt von: Bundesland-Nummer
    #                                                                                            (2-stellig) und: Firmennummer bzw. BLZ
    #                                                                                            (8-stellig) des Zahlungspflichtigen
    # Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN--------------------------------------------------------------------------------------------------------
    # 25  1                 715               num             Meldeschlüssel                    Nur belegt, wenn die Weiterleitung des              K               N                 -                                         K               -
    #                                                                                            Zahlungsauftrages an die Bundesbank auf
    #                                                                                            die statistischen Angaben beschränkt werden
    #                                                                                            soll; (dies sind die Datensätze V, W und Q
    #                                                                                            (ohne Feld Q4) und die Felder 3, 5, 8, 9a,
    #                                                                                            9b, 10a, 10b, 13, 14a, 14b, 15, 16, 17,
    #                                                                                            18, 19 und 24 - 27 des Datensatzes T).
    #                                                                                            Belegung in diesem Falle : ‘1’
    # /Entfällt bei der kurzen Variante NUR FUER DIE BEARBEITUNG DER MELDUNGEN-------------------------------------------------------------------------------------------------------
    # 26  51                716               alpha           -                                 Reserve                                             N               N                 -                                         N               -
    # 27  2                 767               num             Erweiterungskennzeichen           00 = es folgt kein Meldeteil                        P               N                 -                                         P               -
    #
    def add_t(booking)
      data2  = '0768'                                                # PFLICHT, 1 Länge des Datensatzes
      data2 += 'T'                                                   # PFLICHT, 2 Satzart
      data2 += '%08i' % @account.bank_number                         # PFLICHT, 3 BLZ des Einreichinstituts
      data2 += 'EUR'                                                 # PFLICHT, 4a ISO-Währungscode
      data2 += '%010i'  % @account.account_number                    # PFLICHT, 4b Kontonummer
      data2 += @date.strftime("%y%m%d")                              # KANN, 5 Ausführungstermin Einzelzahlung, wenn abweichend von Feld Q8
      data2 += '%08i'  % 0                                           # KANN/PFLICHT 6 BLZ
      data2 += '%03s' % ''                                           # KANN/PFLICHT 7a ISO-Währungscode
      data2 += '%010i' % 0                                           # KANN/PFLICHT 7b BLZ
      data2 += '%-011s' % booking.account.bank_number                 # KANN/PFLICHT 8 11 Bank Identifier Code (BIC) des Zahlungsdienstleisters des Zahlungsempfängers (AUCH BLZ denke ich)
      data2 += '%-03s'  % '' #booking.account.bank_country_code           # KANN/PFLICHT 9a 3 Ländercode für den Zahlungsdienstleister des Zahlungsempfängers
      data2 += '%070s' % ''  #booking.account.bank_name                   # KANN/PFLICHT 9b 4x35 Anschrift des Zahlungsdienstleisters des Zahlungsempfängers - Pflichtfeld wenn T8 nich belegt Zeile 1 und 2:
      data2 += '%035s' % ''  #booking.account.street                      # KANN/PFLICHT 9b Name Zeile 3	: Straße Zeile
      data2 += '%035s' % ''  #booking.account.zip_city                    # KANN/PFLICHT 9b 4	: Ort
      data2 += '%-03s' % booking.account.client_country_code         # PFLICHT 10a Ländercode für Land des Zahlungsempfängers bzw. Scheckempfängers
      data2 += '%-035s' % booking.account.client_firstname                 # KANN/PFLICHT 10b 4x35 Anschrift des Zahlungsdienstleisters des Zahlungsempfängers - Pflichtfeld wenn T8 nich belegt Zeile 1 und 2:
      data2 += '%-035s' % booking.account.client_surname                 # KANN/PFLICHT 10b 4x35 Anschrift des Zahlungsdienstleisters des Zahlungsempfängers - Pflichtfeld wenn T8 nich belegt Zeile 1 und 2:
      data2 += '%-035s' % booking.account.client_street               # KANN/PFLICHT 10b Name Zeile 3	: Straße Zeile
      data2 += '%-035s' % booking.account.client_zip_city             # KANN/PFLICHT 10b 4	: Ort
      data2 += '%070s' % ''                                          # KANN/PFLICHT 11 Ordervermerk
      data2 += '/%-034s' % booking.account.account_number              # PFLICHT 12 35 IBAN bzw. Kontonummer des
      data2 += 'EUR'                                                 # KANN/PFLICHT 13 3 Auftragswährung "EUR"
      data2 += '%014i' % booking.value.divmod(100)[0]                # PFLICHT 14a 14 Betrag (Vorkommastellen) Rechtsbündig
      data2 += '%02i0' % booking.value.divmod(100)[1]                # PFLICHT 14b 3 Betrag (Nachkommastellen) Linksbündig
      data2 += '%0140s' % booking.text || default_text                          # KANN 15 4x35 Verwendungszweck
      data2 += "%02i" % 0                                           # N 16 Weisungsschlüssel 1 (gem. Anhang 2)
      data2 += "%02i" % 0                                           # N 17 Weisungsschlüssel 2 (gem. Anhang 2)
      data2 += "%02i" % 0                                           # N 18 Weisungsschlüssel 3 (gem. Anhang 2)
      data2 += "%02i" % 0                                           # N 19 Weisungsschlüssel 4 (gem. Anhang 2 und 2a)
      data2 += '%025s' % ''                                         # N 20 Zusatzinformationen zum Weisungsschlüssel
      data2 += "%02i" % 0                                            # PFLICHT 21 Entgeltregelung
      data2 += "%02i" % 13                                            # PFLICHT 22 Kennzeichnung der Zahlungsart     Gemäß Anhang 1; Zahlungen, die weder '11' noch '13' als Zahlungsartschlüssel enthalten
      data2 += '%027s' % ''                                          # KANN 23 Variabler Text nur für Auftraggeberabrechnung
      # i dont know what to do.
      data2 += '%035s' % ''                                          # KANN/PFLICHT 24 35 Name und Telefonnummer sowie ggf. Stellvertretungsmeldung
      data2 += '%01i' % 0                                            # KANN/NICHT 25 Meldeschlüssel
      data2 += '%051s' % ''                                           # N 26 Reserve
      data2 += '%02i' % 0                                            # PFLICHT/NICHT 27 2 Erweiterungskennzeichen           00 = es folgt kein Meldeteil
      raise "DTAUS: Längenfehler T (#{data2.size} <> 768)\n" if data2.size != 768
      dta_string << data2
    end

    #Erstellen V-Segment der DTAZV-Datei
    # - V Meldedatensatz zum Transithandel mit 256 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    # Feld  Länge in Bytes  1. Stelle im Satz Feldart Datenformat Inhalt                                                  Erläuterungen
    # 1     4               1                 P       binär/num   Satzlänge                                               Längenangabe des Satzes nach den Konventionen für variable Satzlänge (binär bei Bändern, numerisch bei Disketten und DFÜ)
    # 2     1               5                 P       alpha       Satzart                                                 Konstante "V"
    # 3     27              6                 P       alpha       Warenbezeichnung der eingekauften Transithandelsware    -
    # 4a    2               33                P       num         Kapitel-Nummer des Warenverzeichnisses                  Gemäß Warenverzeichnis für die Außenhandelsstatistik.
    #                                                             für die eingekaufte Transithandelsware
    # 4b    7               35                P       num         "0000000“                                               Konstante "0000000“
    # 5     7               42                P       alpha       Einkaufsland Transithandel                              Kurzbezeichnung gemäß Länderverzeichnis für die Zahlungsbilanzstatistik
    # 6     3               49                P       alpha       Ländercode für Einkaufsland Transithandel               2-stelliger ISO-alpha-Ländercode gemäß Länderverzeichnis für die Zahlungs­ bilanzstatistik; linksbündig zu belegen; 3. Stelle Leerzeichen
    # 7     12              52                P       num         Einkaufspreis Transithandel (Vorkommastellen)           Angabe in Auftragswährung (siehe Feld T13) ; bei Euro-Gegenwertzahlungen : Angabe in Euro und Feld T19 mit ’91‘ belegen.
    # 8     1               64                P       alpha       Verkauf der Transithandelsware an Gebietsfremde         Ja (= J) bzw. Nein (= N)
    #                                                             (durchgehandeltes Transithandels­ geschäft)
    # 9     1               65                P       alpha       Kennzeichnung Verkauf der Transithandelsware            Ja (= J) bzw. Nein (= N)
    #                                                              an Gebietsansässige (gebrochenes
    #                                                              Transithandelsgeschäft)
    # 10    1               66                N       alpha       -                                                       Reserve
    # 11    1               67                P       alpha       Kennzeichnung Transithandelsware unverkauft             Ja (= J) bzw. Nein (= N)
    #                                                              auf Lager im Ausland
    # 12    27              68                K/P     alpha       Warenbezeichnung der verkauften Transithandelsware      Nur belegt, wenn durchgehandelter Transithandel (J in Feld V8) und nicht identisch mit Feld V3
    # 13a   2               95                K/P     num         Kapitel-Nummer des Warenverzeichnisses für die          Gemäß Warenverzeichnis für die Außenhandelsstatistik; nur belegt, wenn durchge­ handelter Transithandel (J in Feld V8) und wenn Feld V13a nicht identisch mit Feld V4a
    #                                                              verkaufte Transithandelsware
    # 13b   7               97                P       num         "0000000"                                               Konstante "0000000"
    # 14    4               104               K/P     alpha       Fälligkeit Verkaufserlös Transithandel                  Nur belegt, wenn durchgehandelter Transithandel (J in Feld V8), Format: JJMM
    # 15    7               108               K/P     alpha       Käuferland Transithandel                                Kurzbezeichnung gemäß Länderverzeichnis für die Zahlungsbilanzstatistik; nur be­ legt, wenn durchgehandelter Transithandel (J in Feld V8)
    # 16    3               115               K/P     alpha       Ländercode für Käuferland                               2-stelliger ISO-alpha-Ländercode gemäß Länderverzeichnis für die Zahlungs­ bilanzstatistik; linksbündig zu belegen; 3. Stelle Leerzeichen; nur belegt, wenn durchgehandelter Transithandel (J in Feld V8)
    # 17    12              118               K/P     num         Verkaufspreis Transithandel (Vorkommastellen)           Nur belegt, wenn durchgehandelter Transithandel (J in Feld V8); Angabe in Auftragswährung (siehe Feld T13); bei Euro-Gegenwertzahlungen : Angabe in Euro und Feld T19 mit ’91‘ belegen.
    # 18    40              130               K/P     alpha       Ergänzungsangaben Transithandel                         Name und Sitz des Nachkäufers bei gebrochenem Transithandel (J in Feld V9)
    # 19    87              170               N       alpha       -                                                       Reserve
    def add_v
      # data  = '0256'  # 1 Länge des Datensatzes
      # data += 'V'    # 2 Satzart
      # data += '%27s'   % # 3 Warenbezeichnung der eingekauften Transithandelsware
      # data += 4a Kapitel-Nummer des Warenverzeichnisses für die eingekaufte Transithandelsware
      # data += "0000000" # 4b Konstante "0000000“
      # data += '%7s' # 5 Einkaufsland Transithandel
      # data += '%03s' # 6 Ländercode für Einkaufsland Transithandel 2-stelliger ISO-alpha-Ländercode gemäß Länderverzeichnis für die Zahlungs­ bilanzstatistik; linksbündig zu belegen; 3. Stelle Leerzeichen
      # data += '%012i' # 7 Einkaufspreis Transithandel (Vorkommastellen)
      # data += 'J' # 8 Verkauf der Transithandelsware an Gebietsfremde         Ja (= J) bzw. Nein (= N)
      # data += '...' # 9 Kennzeichnung Verkauf der Transithandelsware an Gebietsansässige (gebrochenes Transithandelsgeschäft) Ja (= J) bzw. Nein (= N)
      # data += '%01s' # 10 Reserve
      # data += 'J' # 11 Kennzeichnung Transithandelsware unverkauft             Ja (= J) bzw. Nein (= N)
      # data += '%27s' # 12 Warenbezeichnung der verkauften Transithandelsware      Nur belegt, wenn durchgehandelter Transithandel (J in Feld V8) und nicht identisch mit Feld V3
      # data += '%27s' # 13a Kapitel-Nummer des Warenverzeichnisses für die
      # data += "0000000" # 13b Konstante "0000000"
      # data += '%04s' # 14 Fälligkeit Verkaufserlös Transithandel verkaufte Transithandelsware
      # data += '%07s' # 15 Käuferland Transithandel                                Kurzbezeichnung gemäß Länderverzeichnis für die Zahlungsbilanzstatistik
      # data += '%03s' # 16 Ländercode für Käuferland                               2-stelliger ISO-alpha-Ländercode gemäß Länderverzeichnis für die Zahlungs­ bilanzstatistik; linksbündig zu belegen; 3. Stelle Leerzeichen;
      # data += '%12s' # 17 Verkaufspreis Transithandel (Vorkommastellen)           Nur belegt, wenn durchgehandelter Transithandel
      # data += '%40s' # 18 Ergänzungsangaben Transithandel                         Name und Sitz des Nachkäufers bei gebrochenem Transithandel (J in Feld V9)
      # data += '%87s' # 19 Reserve
    end

    #Erstellen W-Segment der DTAZV-Datei
    # - W Meldedatensatz für Dienstleistungs-, Kapitalverkehr und Sonstiges mit 256 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    # Datensatz W (Datei-Nachsatz)
    # Feld  Länge in Bytes  1. Stelle im Satz Feldart Datenformat Inhalt                          Erläuterungen
    # 1     4               1                 P       binär/num   Satzlänge                       Längenangabe des Satzes nach den Konventionen für variable Satzlänge (binär bei Bändern, numerisch bei Disketten und DFÜ)
    # 2     1               5                 P       alpha       Satzart                         Konstante W
    # 3     1               6                 P       num         Belegart                        Dienstleistungen, Übertragungen	= ‘2’ Kapitaltransaktionen und Kapitalerträge	= ‘4’
    # 4     3               7                 P       num         Kennzahl                        Gemäß Leistungsverzeichnis (Anlage LV zur AWV)
    # 5     7               10                P       alpha       Land                            Kurzbezeichnung gemäß Länderverzeichnis für die Zahlungsbilanzstatistik (siehe Anhang 3, Abschnitt E)
    # 6     3               17                P       alpha       Ländercode                      2-stelliger ISO-alpha-Ländercode gemäß Länderverzeichnis für die Zahlungs­ bilanzstatistik (siehe Anhang 3, Abschnitt E); linksbündig zu belegen; 3. Stelle Leerzeichen
    # 7     7               20                K/P     alpha       Anlageland bei Kapitalverkehr   Kurzbezeichnung gemäß Länderverzeichnis für die Zahlungsbilanzstatistik 3
    # 8     3               27                K/P     alpha       Ländercode für Anlageland       2-stelliger ISO-alpha-Ländercode gemäß Länderverzeichnis für die Zahlungs­ bilanzstatistik 3; linksbündig zu belegen; 3. Stelle Leerzeichen
    # 9     12              30                P       num         Betrag für Dienstleistungen,    Angabe in Auftragswährung (siehe Feld T13); bei Euro-Gegenwertzahlungen : Angabe in Euro und Feld T19 mit ’91‘ belegen.
    #                                                             Kapitalverkehr, Sonstiges
    #                                                             (Vorkommastellen)
    # 10    140             42                P       alpha       nähere Angaben zur zugrunde     Wichtige Einzelheiten des Grundgeschäfts
    #                                                             liegenden Leistung
    # 11    75              182               N       alpha       -                               Reserve
    def add_w
      # data  = '0256'  # 1 Länge des Datensatzes
      # data += 'W'    # 2 Satzart
      # data += '%01s'   % ... # 3 Belegart
      # data += '%03s' % ... # 4 Kennzahl
      # data += '%07s' % ... # 5 Land
      # data += '%3s' # 6 Ländercode
      # data += '%07s'   % ... # 7 Anlageland bei Kapitalverkehr
      # data += '%03s' % ... # 8 Ländercode für Anlageland
      # data += '%012i' % ... # 9 Betrag für Dienstleistungen Kapitalverkehr, Sonstiges (Vorkommastellen)
      # data += '%0140s' # 10 nähere Angaben zur zugrunde liegenden Leistung
      # data += '%075s' # 11 Reserve
    end

    #Erstellen Y-Segment der DTAZV-Datei
    # - Y Datei-Nachsatz mit 256 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    #Aufbau des Segments:
    # Feld  Länge in Bytes  1. Stelle im Satz Feldart Datenformat Inhalt                  Erläuterungen
    # 1     4               1                 P       binär/num   Satzlänge               Längenangabe des Satzes nach den Konventionen für variable Satzlänge (binär bei Bändern, numerisch bei Disketten und DFÜ)
    # 2     1               5                 P       alpha       Satzart                 Konstante Y
    # 3     15              6                 P       num         Betragssumme            Aus Datensätzen U Feld 5 ( = 0, falls keine U-Sätze vorhanden)
    # 4     15              21                P       num         Betragssumme            Aus Datensätzen V Feld 7
    # 5     15              36                P       num         Betragssumme            Aus Datensätzen V Feld 17
    # 6     15              51                P       num         Betragssumme            Aus Datensätzen W Feld 9
    # 7     6               66                P       num         Anzahl der Datensätze   Anzahl Datensätze U, V, W
    # 8     6               72                P       num         Anzahl der Datensätze   Anzahl Datensätze T
    # 9     179             78                P       alpha       Leerzeichen             Reserve
    def add_y(bookings)
      data3  = '0256'                        # 1 Länge des Datensatzes
      data3 += 'Y'                           # 2 Satzart
      data3 += '%015i'   % 0                 # 3 Betragssumme
      data3 += '%015i'   % 0                 # 4 Betragssumme
      data3 += '%015i'   % 0                 # 5 Betragssumme
      data3 += '%015i'   % 0                 # 6 Betragssumme
      data3 += '%06i'    % 0                 # 7 Anzahl der Datensätze
      data3 += '%06i'    % bookings.count    # 8 Anzahl der Datensätze
      data3 += '%0179s'  % ''                 # 9 Leerzeichen Reserve
      raise "DTAUS: Längenfehler T (#{data3.size} <> 256)\n" if data3.size != 256
      dta_string << data3
    end

    # THE MAGICAL Z SEGMENT
    def add_z(bookings)
      data3  = '0256'
      data3 += 'Z'
      sum = 0
      bookings.each do |b|
        sum += b.value.divmod(100)[0]
      end
      data3 += '%015i'   % sum
      data3 += '%015i'   % bookings.count
      data3 += '%0221s'  % ''
      raise "DTAUS: Längenfehler Z (#{data3.size} <> 256)\n" if data3.size != 256
      dta_string << data3
    end

  end
end