# encoding: utf-8
module KingDta
  class Dta
    include KingDta::Helper
    attr_reader :default_text

    # Create a new dta string.
    # === Parameter    #
    # typ<Date>:: date when the the transfer is to be created
    def initialize(date=Date.today )
      raise ArgumentError.new("Wrong date format. Make it a Time or Date object with yyyy-mm-dd") unless date.respond_to?(:strftime)
      @date         = date
      @value_pos    = true  #values are positive by default changed by first booking
      @closed       = false
      @default_text = ''
    end
    #  Set the sending account(you own)
    # === Parameter
    # account<Account>:: the sending account, must be an instance of class
    # KingDta::Account
    def account=( account )
      raise Exception.new("Come on, i need an Account object") unless account.kind_of?( Account )
      @account = account
    end

    # The dtaus format as string. All data is appended to it during creation
    def dta_string
      @dta_string ||= ''
    end
    # Array of bookings
    def bookings
      @bookings ||= []
    end
    # default text used on all bookings with emtpy text
    def default_text=(text='')
      @default_text = convert_text( text )
    end

    # Add a booking. The prefix (pos/neg) is beeing checked if it is identical
    # with the last one
    # === Parameter
    # booking<Booking>:: KingDta::Booking object
    # === Raises
    # error if the prefix within the bookings has changed
    def add ( booking )
      raise Exception.new("The file has alreay been closed, cannot add new booking") if @closed
      #the first booking decides wether all values are po or negative
      @value_pos = booking.pos?  if bookings.empty?
      raise Exception.new("The prefix within bookings changed from #{@value_pos} to #{booking.pos?}") if @value_pos != booking.pos?
      bookings << booking
    end

    # Create a DTA-File, from current dta information
    # === Parameter
    # filename<String>:: defaults to dta.txt
    def create_file(filename ='dta.txt')
      file = open( filename, 'w')
      file  << create
      file.close()
    end

  end
end
