$:.unshift(File.dirname(__FILE__))
$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rubygems'
require "king_dtaus"
require 'rspec'
require 'ostruct'
require 'date'

class Dtazv


  def dudes_konto
    opts = {
              :bank_account_number => '1326049634',
              :bank_number => '37050299',
              :bank_name => 'Kreissparkasse Köln',
              :zweck => 'Monatsbeitrag',
              :account_street => "Bank Eine Straße 2",
              :account_city => "Bank Köln",
              :account_zip_code => "51063",
              :owner_number => "",
              :owner_name =>'Jan Kus',
              :owner_street => "Meine Eine Straße 2",
              :owner_city => "Meine Köln",
              :owner_zip_code => "51063",
              :bank_country_code => "DE",
              :owner_country_code => "DE"
            }
    TestKonto.new(opts)
  end

  def dalai_lamas_account
    opts = {
              :bank_account_number => 'GR1601101250000000012300695',
              :bank_number => 'MARKF1100',
              :bank_name => 'Dalai Lamas Bank',
              :zweck => 'Lama Fee',
              :account_street => "5th avenue",
              :account_city => "los angeles",
              :account_zip_code => "55323",
              :owner_number => "",
              :owner_name =>'Dalai Lama',
              :owner_street => "Bush-Avenue 55",
              :owner_city => "India",
              :owner_zip_code => "066600",
              :owner_zip_code => "445555",
              :bank_country_code => "DE",
              :owner_country_code => "DE"
            }
    TestKonto.new(opts)
  end
  # The DTAVZ format as string. All data is appended to it during creation
  def dta_string
    @dta_string ||= ''
  end

  def create_dtazv
    @dtazv = KingDta::Dtazv.new(Date.today)
    @dudes_konto = dudes_konto
    @dalai_lamas_account = dalai_lamas_account

    @dtazv.account = KingDta::Account.new(
      :bank_account_number =>      @dudes_konto.bank_account_number,
      :bank_number =>         @dudes_konto.bank_number,
      :owner_name =>         @dudes_konto.owner_name,
      :owner_number =>       @dudes_konto.owner_number,
      :bank_street =>         @dudes_konto.account_street,
      :bank_city =>           @dudes_konto.account_city,
      :bank_zip_code =>       @dudes_konto.account_zip_code,
      :bank_name =>           @dudes_konto.bank_name,
      :owner_street =>       @dudes_konto.owner_street,
      :owner_city =>         @dudes_konto.owner_city,
      :owner_zip_code =>     @dudes_konto.owner_zip_code,
      :bank_country_code =>   @dudes_konto.bank_country_code,
      :owner_country_code => @dudes_konto.owner_country_code
    )

    @dalai_lamas_booking = KingDta::Booking.new(KingDta::Account.new(
      :bank_account_number =>      @dalai_lamas_account.bank_account_number,
      :bank_number =>         @dalai_lamas_account.bank_number,
      :owner_name =>         @dalai_lamas_account.owner_name,
      :owner_number =>       @dalai_lamas_account.owner_number,
      :bank_street =>         @dalai_lamas_account.account_street,
      :bank_city =>           @dalai_lamas_account.account_city,
      :bank_zip_code =>       @dalai_lamas_account.account_zip_code,
      :bank_name =>           @dalai_lamas_account.bank_name,
      :owner_street =>       @dalai_lamas_account.owner_street,
      :owner_city =>         @dalai_lamas_account.owner_city,
      :owner_zip_code =>     @dalai_lamas_account.owner_zip_code,
      :bank_country_code =>   @dalai_lamas_account.bank_country_code,
      :owner_country_code => @dalai_lamas_account.owner_country_code
    ), 220.25)

    @dtazv.add(@dalai_lamas_booking)
    puts @dtazv.create
  end

  # the test account responds to everything
  class TestKonto < OpenStruct; end

end

d = Dtazv.new
d.create_dtazv