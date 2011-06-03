module KingDta
  module DtazvSegments

    #Erstellen P-Segment der DTAZV-Datei
    # - P Datei-Vorsatz mit 256 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    #Aufbau des Segments:
    # Nr.  Start  Länge     Beschreibung
    # 1   0      4 Zeichen    Länge des Datensatzes, immer 128 Bytes, also immer "0128"
    def add_p

    end

    #Erstellen Q-Segment der DTAZV-Datei
    # - Q Auftraggebersatz mit 256 oder 246 Bytes (= Datei-Vorsatz aus dem Datenaustausch zwischen Kunde und Bank)
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    #Aufbau des Segments:
    # Nr.  Start  Länge     Beschreibung
    # 1   0      4 Zeichen    Länge des Datensatzes, immer 128 Bytes, also immer "0128"
    def add_q

    end

    #Erstellen T-Segment der DTAZV-Datei
    # - T Einzelzahlungssatz mit 768 oder 572 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    #Aufbau des Segments:
    # Nr.  Start  Länge     Beschreibung
    # 1   0      4 Zeichen    Länge des Datensatzes, immer 128 Bytes, also immer "0128"
    def add_t

    end

    #Erstellen V-Segment der DTAZV-Datei
    # - V Meldedatensatz zum Transithandel mit 256 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    #Aufbau des Segments:
    # Nr.  Start  Länge     Beschreibung
    # 1   0      4 Zeichen    Länge des Datensatzes, immer 128 Bytes, also immer "0128"
    def add_v

    end

    #Erstellen W-Segment der DTAZV-Datei
    # - W Meldedatensatz für Dienstleistungs-, Kapitalverkehr und Sonstiges mit 256 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    #Aufbau des Segments:
    # Nr.  Start  Länge     Beschreibung
    # 1   0      4 Zeichen    Länge des Datensatzes, immer 128 Bytes, also immer "0128"
    def add_w

    end

    #Erstellen Y-Segment der DTAZV-Datei
    # - Y Datei-Nachsatz mit 256 Bytes
    # === Parameter
    # booking<Object>::Booking object to be written to c-sektion
    #
    # === Returns
    # <String>:: The current dta_string
    #Aufbau des Segments:
    # Nr.  Start  Länge     Beschreibung
    # 1   0      4 Zeichen    Länge des Datensatzes, immer 128 Bytes, also immer "0128"
    def add_y

    end

  end
end
