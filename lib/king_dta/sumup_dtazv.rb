# encoding: utf-8

module KingDta
  class SumupDtazv < Dtazv

    attr_accessor :currency_code
    attr_reader :payment_type

    # Class constant.
    GBP = 'GBP'

    def initialize(currency_code)
      super(Date.today)
      # Using self because I want to call the mutator method defined below.
      self.currency_code = currency_code
    end
    def add_t(booking)

      # Update to the original add_t method in the parent class.
      # This will allow us to specify a currency and add some text 
      # for the customer's bill.

      data2  = '0768'
      data2 += 'T'
      data2 += '%08i' % @account.bank_number
      data2 += @currency_code
      data2 += '%010i'  % @account.bank_account_number
      data2 += @date.strftime("%y%m%d")                             # KANN, 5 Ausführungstermin Einzelzahlung, wenn abweichend von Q8
      data2 += '%08i'  % 0                                          # KANN/PFLICHT 6 BLZ
      data2 += '%03s' % ''                                          # KANN/PFLICHT 7a ISO-Währungscode
      data2 += '%010i' % 0                                          # KANN/PFLICHT 7b BLZ
      data2 += '%-011s' % booking.account.bank_bic
      data2 += '%-03s'  % booking.account.bank_country_code         # Pflichtfelder wenn T8 leer
      data2 += '%-070s' % booking.account.bank_name
      data2 += '%-035.35s' % booking.account.bank_street
      data2 += '%-035.35s' % booking.account.bank_zip_city
      data2 += '%-03s' % booking.account.owner_country_code         # PFLICHT 10a Ländercode für Land des Zahlungsempfängers
      data2 += '%-035.35s' % booking.account.owner_name[0..34]      # Zahlungsempfänger
      data2 += '%-035.35s' % booking.account.owner_name[35..69]
      data2 += '%-035.35s' % booking.account.owner_street
      data2 += '%-035.35s' % booking.account.owner_zip_city
      data2 += '%070s' % ''                                         # KANN/PFLICHT 11 Ordervermerk
      data2 += '/%-034s' % booking.account.bank_iban                # PFLICHT 12 35 IBAN bzw. Kontonummer des
      data2 += @currency_code                                                # KANN/PFLICHT 13 3 Auftragswährung "EUR"
      data2 += '%014i' % booking.value.divmod(100)[0]               # PFLICHT 14a 14 Betrag (Vorkommastellen) Rechtsbündig
      data2 += '%02i0' % booking.value.divmod(100)[1]               # PFLICHT 14b 3 Betrag (Nachkommastellen) Linksbündig
      data2 += '%-0140s' % (booking.text || default_text)
      data2 += "%02i" % 0                                           # N 16 Weisungsschlüssel 1 (gem. Anhang 2)
      data2 += "%02i" % 0                                           # N 17 Weisungsschlüssel 2 (gem. Anhang 2)
      data2 += "%02i" % 0                                           # N 18 Weisungsschlüssel 3 (gem. Anhang 2)
      data2 += "%02i" % 0                                           # N 19 Weisungsschlüssel 4 (gem. Anhang 2 und 2a)
      data2 += '%025s' % ''                                         # N 20 Zusatzinformationen zum Weisungsschlüssel
      data2 += "%02i" % 0                                           # PFLICHT 21 Entgeltregelung
      #TODO: Need to edit this 13 because 13 is only for EUR we need 00 for GBP
      data2 += "%02i" % payment_type                                          # PFLICHT 22 Kennzeichnung der Zahlungsart     Gemäß Anhang 1; Zahlungen, die weder '11' noch '13' als Zahlungsartschlüssel enthalten
      data2 += '%-027s' % (booking.customer_bill_text || '')                                         # KANN 23 Variabler Text nur für Auftraggeberabrechnung
      # i dont know what to do.
      data2 += '%035s' % ''                                         # KANN/PFLICHT 24 35 Name und Telefonnummer sowie ggf. Stellvertretungsmeldung
      data2 += '%01i' % 0                                           # KANN/NICHT 25 Meldeschlüssel
      data2 += '%051s' % ''
      data2 += '%02i' % 0                                            # Erweiterungskennzeichen  00 = es folgt kein Meldeteil
      raise "DTAUS: Längenfehler T (#{data2.size} <> 768)\n" if data2.size != 768
      dta_string << data2

    end

    def currency_code=(currency_code)
      raise Exception.new("Currency code must be of lnegth 3.") if currency_code.size > 3
      @currency_code = currency_code 
    end

    private
    def payment_type
      @payment_type = (@currency_code == GBP ? 00 : 13)
    end
  end
end
