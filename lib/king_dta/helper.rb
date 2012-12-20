# encoding: utf-8
module KingDta
  module Helper
    #Zeichen umsetzen gemäss DTA-Norm
    def convert_text( text)
      text = text.to_s
      return text if text.empty?
      raise "Text kein String >#{text}< (#{text.class})" unless text.kind_of?( String ) # not possible
      text.gsub!('Ä', 'AE')
      text.gsub!('Ü', 'UE')
      text.gsub!('Ö', 'OE')
      text.gsub!('ä', 'AE')
      text.gsub!('ü', 'UE')
      text.gsub!('ö', 'OE')
      text.gsub!('ß', 'SS')
      text.gsub(/[àáâãå]/,'A')
      text.gsub(/æ/,'AE')
      text.gsub(/ç/, 'C')
      text.gsub(/[èéêë]/,'E')

      text = I18n.transliterate(text)

      text.gsub! /[^a-zA-Z0-9\ \.\,\&\-\/\+\*\$\%]/, '' # Remove all invalid chars
      text.upcase.strip
    end
  end
end
