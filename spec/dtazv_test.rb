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

  def fidel_castros_account
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

  # The DTAVZ format as string. All data is appended to it during creation
  def dta_string
    @dta_string ||= ''
  end

  def create_dtazv
    @date = Date.today
    @dudes_dtazv_export = KingDta::Dtazv.new(@date)
    @dudes_konto = self.dudes_konto
    @fidel_castros_account = self.fidel_castros_account
    @dudes_dtazv_export.account = KingDta::Account.new(
      @dudes_konto.account_number,
      @dudes_konto.bank_number,
      @dudes_konto.client_name,
      @dudes_konto.client_number,
      @dudes_konto.account_street,
      @dudes_konto.account_city,
      @dudes_konto.account_zip_code,
      @dudes_konto.bank_name,
      @dudes_konto.client_street,
      @dudes_konto.client_city,
      @dudes_konto.client_zip_code,
      @dudes_konto.bank_country_code,
      @dudes_konto.client_country_code
    )

    @fidel_castros_booking = KingDta::Booking.new(KingDta::Account.new(
      @fidel_castros_account.account_number,
      @fidel_castros_account.bank_number,
      @fidel_castros_account.client_name,
      @fidel_castros_account.bank_name,
      @fidel_castros_account.account_street,
      @fidel_castros_account.account_city,
      @fidel_castros_account.account_zip_code,
      @fidel_castros_account.bank_name,
      @fidel_castros_account.client_street,
      @fidel_castros_account.client_city,
      @fidel_castros_account.client_zip_code,
      @fidel_castros_account.bank_country_code,
      @fidel_castros_account.client_country_code
    ), 220.25)

    @dudes_dtazv_export.add(@fidel_castros_booking)
    @dudes_dtazv_export.create_file
  end

  # the test account responds to everything
  class TestKonto < OpenStruct; end

end

d = Dtazv.new
d.create_dtazv