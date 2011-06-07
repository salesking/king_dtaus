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
              :account_number => '7828970037',
              :bank_number => '37040044',
              :bank_name => 'Commerzbank Köln',
              :zweck => 'Monatsbeitrag',
              :account_street => "5th avenue",
              :account_city => "los angeles",
              :account_zip_code => "55323",
              :client_number => "",
              :client_name =>'Gimme your Money AG',
              :client_street => "6th avenue",
              :client_city => "los angeles",
              :client_zip_code => "445555",
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
    @fidel_castros_booking = KingDta::Booking.new(
                                                  KingDta::Account.new(
                                                    @fidel_castros_account.account_number,
                                                    @fidel_castros_account.bank_number,
                                                    @fidel_castros_account.client_name,
                                                    @fidel_castros_account.bank_name
                                                  ),
                                                  220.25)

    # @dta_string = dta_string.empty? ? dta_string : ''
    # dta_string << @dudes_dtazv_export.add_p
    # dta_string << @dudes_dtazv_export.add_q
    # dta_string << @dudes_dtazv_export.add_t(@fidel_castros_booking)
    # dta_string << @dudes_dtazv_export.add_y(1)
    # puts dta_string
    @dudes_dtazv_export.add(@fidel_castros_booking)
    @dudes_dtazv_export.create
  end

  # the test account responds to everything
  class TestKonto < OpenStruct; end

end

d = Dtazv.new
d.create_dtazv