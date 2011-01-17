# encoding: utf-8
require 'rubygems'
require 'ostruct'
require 'date'
require "#{File.dirname(__FILE__)}/../lib/king_dtaus"

#Filename der eigenen Kontodaten
#		Beispiel:
#			typ:LK
#			blz:99988811
#			konto:123456
#			bank:Nord-Ostschwaebische Sandbank
#
#			name:Jodelverein Holladrioe 1863 e.V.
#			zweck:Mitgliedsbeitrag 2003
#		Der Typ ist LK oder GK. Siehe Option -t
#		zweck ist ein optionaler Default-Text, der verwendet wird,
#		falls eine Buchung keinen Text hat.
#		Die Adressdaten der Bank sind optional und werdezum erzeugen
#		des Begleitblatts verwendet
#     bankstrasse:Kieselweg 3
#			bankplz:0815
#			bankort:Felsblock
def test_kto1
  opts = { :nr => '2880037', :blz => '37040044', :name =>'Gimme your Money AG',
            :bank => 'Commerzbank Köln', :zweck => 'Monatsbeitrag' }
  TestKonto.new(opts)
end

def test_kto2
  opts = { :nr => '2787777', :blz => '37040044', :name =>'Peter & May GmbH',
          :bank => 'Commerzbank Köln', :zweck => 'Monatsbeitrag' }
  TestKonto.new(opts)
end

def test_kto3
  opts = { :nr => '2787777', :blz => '37040044', :name =>'Andrew Müller',
          :bank => 'Commerzbank Köln', :zweck => 'Monatsbeitrag' }
  TestKonto.new(opts)
end

# the test account responds to everything
class TestKonto < OpenStruct; end
