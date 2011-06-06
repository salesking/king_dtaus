# encoding: utf-8

$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require "king_dtaus"
require 'rspec'
require 'ostruct'
require 'date'

RSpec.configure do |config|
end


#Filename der eigenen Kontodaten
#    Beispiel:
#      typ:LK
#      blz:99988811
#      konto:123456
#      bank:Nord-Ostschwaebische Sandbank
#
#      name:Jodelverein Holladrioe 1863 e.V.
#      zweck:Mitgliedsbeitrag 2003
#    Der Typ ist LK oder GK. Siehe Option -t
#    zweck ist ein optionaler Default-Text, der verwendet wird,
#    falls eine Buchung keinen Text hat.
#    Die Adressdaten der Bank sind optional und werdezum erzeugen
#    des Begleitblatts verwendet
#     bankstrasse:Kieselweg 3
#      bankplz:0815
#      bankort:Felsblock

def dudes_konto
  opts = {
            :account_nr => '7828970037',
            :account_bank_number => '37040044',
            :account_bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :account_street => "5th avenue",
            :account_city => "los angeles",
            :account_zip_code => "55323",
            :client_number => "",
            :sender_name =>'Gimme your Money AG',
            :sender_street => "6th avenue",
            :sender_city => "los angeles",
            :sender_zip_code => "445555"
          }
  TestKonto.new(opts)
end

def test_kto1
  opts = {
            :account_nr => '7828970037',
            :account_bank_number => '37040044',
            :sender_name =>'Gimme your Money AG',
            :account_bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :client_number => ""
          }
  TestKonto.new(opts)
end

def test_kto2
  opts = {
            :account_nr => '2787777',
            :account_bank_number => '37040044',
            :sender_name =>'Peter & May GmbH',
            :account_bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :client_number => ""
          }
  TestKonto.new(opts)
end

def test_kto3
  opts = {
            :account_nr => '2787777',
            :account_bank_number => '37040044',
            :sender_name =>'Andrew Müller',
            :account_bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :client_number => ""
          }
  TestKonto.new(opts)
end

# the test account responds to everything
class TestKonto < OpenStruct; end
