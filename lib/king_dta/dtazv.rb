module KingDta
  class Dtazv
    include KingDta::Helper
    include KingDta::DtazvSegments

    # needed?
    attr_reader :default_text #, :sum_bank_account_numbers, :sum_bank_numbers, :sum_values

    # Create a new dtazv file/string.
    # ===Parameter
    # typ<Date>:: date when the the transfer is to be created
    def initialize(date=Date.today)
      raise ArgumentError.new("Wrong date format. Make it a Time or Date object with yyyy-mm-dd") unless date.respond_to?(:strftime)
      @date = date
      @value_pos  = true  #all values are positive by default. Variable changes with first booking entry
      @closed     = false
      @default_text = 'Want some? Come, get some!' # default verwendungzweck
    end

    #  Set the sending account(you own)
    # === Parameter
    # account<Account>:: the sending account, must be an instance of class
    # KingDta::Account
    def account=( account )
      raise Exception.new("Come on, i need an Account object") unless account.kind_of?( Account )
      @account = account
    end

    # The DTAVZ format as string. All data is appended to it during creation
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
      @value_pos = booking.pos? if bookings.empty?
      raise Exception.new("The prefix within bookings changed from #{@value_pos} to #{booking.pos?}") if @value_pos != booking.pos?
      bookings << booking
    end

    # Creates the whole dta string(in the right order) and returns it
    # === Raises
    # error if there are no bookings
    def create
      raise Exception.new("Cannot create DTAUS without bookings") if bookings.empty?
      @closed = true
      # cleanup before we start
      @dta_string = dta_string.empty? ? dta_string : ''

      # TODO CHANGE THIS
      # set_checksums
      # add_a
      # bookings.each{ |b| add_c( b) }
      # add_e
      # dta_string
    end

    # TODO why this checksums are being created?
    def set_checksums
      @sum_bank_account_numbers, @sum_bank_numbers, @sum_values  = 0,0,0
      bookings.each do |b|
        @sum_bank_account_numbers  += b.account.bank_account_number
        @sum_bank_numbers += b.account.bank_number
        @sum_values += b.value
      end
    end

    # Create a DTA-File, from current dta information
    # === Parameter
    # filename<String>:: defaults to DTAUS0.TXT
    def create_file(filename ='DTAUS0.TXT')
      file = open( filename, 'w')
      file  << create
      file.close()
      print "#{filename} created containing #{@bookings.size} bookings\n"
    end

  end
end