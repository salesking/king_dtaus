module KingDta
  module Helper
    #Zeichen umsetzen gemäss DTA-Norm
    def convert_text( text)
      text = text.to_s
      return text if text.empty?
      raise "Text kein String >#{text}< (#{text.class})" unless text.kind_of?( String )
      text.gsub!('Ä', 'AE')
      text.gsub!('Ü', 'UE')
      text.gsub!('Ö', 'OE')
      text.gsub!('ä', 'AE')
      text.gsub!('ü', 'UE')
      text.gsub!('ö', 'OE')
      text.gsub!('ß', 'SS')
      
      text.gsub! /[^a-zA-Z0-9\ \.\,\&\-\/\+\*\$\%]/, '' # Remove all invalid chars
      
      text = text.upcase.strip
      text
#		text = text.to_s()
#		puts "Text kein String >#{text}< (#{text.class})" if ! text.kind_of?( String )
#		text = text.upcase()
#		text = text.gsub('Ä', 'AE')
#		text = text.gsub('Ü', 'UE')
#		text = text.gsub('Ö', 'OE')
#		text = text.gsub('ä', 'AE')
#		text = text.gsub('ü', 'UE')
#		text = text.gsub('ö', 'OE')
#		text = text.gsub('ß', 'SS')
#		return text = text.strip
    end
  end
end