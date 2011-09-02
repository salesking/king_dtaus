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

RSpec.configure do |config|
end


def sender_opts
  {
    :bank_account_number => '1326049634',
    :bank_number => '37050299',
    :bank_name => 'Kreissparkasse Köln',
    :bank_street => "Bank Eine Straße 2",
    :bank_city => "Bank Köln",
    :bank_zip_code => "51063",
    :owner_number => "",
    :owner_name =>'Jan Kus',
    :owner_street => "Meine Eine Straße 2",
    :owner_city => "Meine Köln",
    :owner_zip_code => "51063",
    :bank_country_code => "DE",
    :owner_country_code => "DE"
  }
end

def receiver_opts
  {
    :bank_account_number => 'GR1601101250000000012300695',
    :bank_number => 'MARKF1100',
    :bank_name => 'Dalai Lamas Bank',
    :bank_street => "5th avenue",
    :bank_city => "los angeles",
    :bank_zip_code => "55323",
    :owner_number => "",
    :owner_name =>'Dalai Lama',
    :owner_street => "Bush-Avenue 55",
    :owner_city => "India",
    :owner_zip_code => "445555",
    :bank_country_code => "DE",
    :owner_country_code => "DE"
  }
end

def test_kto1
  opts = {
            :bank_account_number => '7828970037',
            :bank_number => '37040044',
            :owner_name =>'Gimme your Money AG',
            :bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :owner_number => ""
          }
  TestKonto.new(opts)
end

def test_kto2
  opts = {
            :bank_account_number => '2787777',
            :bank_number => '37040044',
            :owner_name =>'Peter & May GmbH',
            :bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :owner_number => ""
          }
  TestKonto.new(opts)
end

def test_kto3
  opts = {
            :bank_account_number => '2787777',
            :bank_number => '37040044',
            :owner_name =>'Andrew Müller',
            :bank_name => 'Commerzbank Köln',
            :zweck => 'Monatsbeitrag',
            :owner_number => ""
          }
  TestKonto.new(opts)
end

# the test account responds to everything
class TestKonto < OpenStruct; end
