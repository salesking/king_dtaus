# encoding: utf-8
$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'simplecov'
SimpleCov.start 'rails'
SimpleCov.coverage_dir 'coverage/rspec'

require 'rubygems'
require "king_dtaus"
require 'rspec'
require 'ostruct'
require 'date'
require 'mocha'

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
            :account_number => '1326049634',
            :bank_number => '37050299',
            :bank_name => 'Kreissparkasse Köln',
            :zweck => 'Monatsbeitrag',
            :account_street => "Bank Eine Straße 2",
            :account_city => "Bank Köln",
            :account_zip_code => "51063",
            :client_number => "",
            :client_name =>'Jan Kus',
            :client_street => "Meine Eine Straße 2",
            :client_city => "Meine Köln",
            :client_zip_code => "51063",
            :bank_country_code => "DE",
            :client_country_code => "DE"
          }
  TestKonto.new(opts)
end

def dalai_lamas_account
  opts = {
            :account_number => 'GR1601101250000000012300695',
            :bank_number => 'MARKF1100',
            :bank_name => 'Kuba National Bank',
            :zweck => 'President-Fee',
            :account_street => "5th avenue",
            :account_city => "los angeles",
            :account_zip_code => "55323",
            :client_number => "",
            :client_name =>'Fidel Castro',
            :client_street => "Bush-Avenue 55",
            :client_city => "Kuba",
            :client_zip_code => "066600",
            :client_zip_code => "445555",
            :bank_country_code => "DE",
            :client_country_code => "DE"
          }
  TestKonto.new(opts)
end

def test_kto1
  opts = {
            :account_number => '7828970037',
            :bank_number => '37040044',
            :client_name =>'Gimme your Money AG',
            :bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :client_number => ""
          }
  TestKonto.new(opts)
end

def test_kto2
  opts = {
            :account_number => '2787777',
            :bank_number => '37040044',
            :client_name =>'Peter & May GmbH',
            :bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :client_number => ""
          }
  TestKonto.new(opts)
end

def test_kto3
  opts = {
            :account_number => '2787777',
            :bank_number => '37040044',
            :client_name =>'Andrew Müller',
            :bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :client_number => ""
          }
  TestKonto.new(opts)
end

# the test account responds to everything
class TestKonto < OpenStruct; end
