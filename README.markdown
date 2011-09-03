# DTAUS & DTAZV always comes together

[![Build Status](https://secure.travis-ci.org/salesking/king_dtaus.png)](http://travis-ci.org/salesking/king_dtaus)

DTAUS & DTAZV are formats for German bank transfers and is short for
"Datenträgeraustausch". The format itself totally sucks because it was
established in the last century, to be used on floppy disks. Still almost
all German banks use it (they only seem innovative at robbing), and it is
therefore supported in common banking programs too.

This gem saves you all the trouble when generating DTAUS- or DTAZV-text.

We love building payment applications.

## Install

    gem install king_dtaus

## Features

* Create DTAUS debit advice (Lastschrift)
* Create DTAUS credit advice (Gutschrift)
* Create DTAZV debit advice
* High test coverage to ensure software quality

## Beta Version Info

We are working on version 2 of the gem with some breaking changes!

* account attributes now passed in as hash
* renamed of account attributes client_xy => owner_xy
* renamed account.account_number to bank_account_number
* added iban/bic to account
* DTAZV added

To try it use:
  gem install king_dtaus --pre
  # or add a pre version to your Gemfile
  gem 'king_dtaus', '2.0.3.pre'

## TODOs

* first gem with no todo's - never seen it, huh? - just kidding
* some more edge-case tests needed

## Resources

* SalesKing: http://salesking.eu
* DTAZV-Viewer: http://www.meta-evolutions.de/pages/artikel-20070630-dtazv-datei-betrachter.html
* DTA/DTAZV PHP Pear: http://pear.php.net/package/Payment_DTA
* Ruby Kernel Module: http://www.ruby-doc.org/core/classes/Kernel.html
* Windata ZV-Tools: http://www.windata.de/Site/2Produkte2/ZVTools.aspx
* The Swift Codes: http://www.theswiftcodes.com/
* StarMoney: http://www.starmoney.de/index.php?id=starmoneybusiness_testen

## Examples

Here are some examples how to create a DTA- or DTAZV-File. Also check out the spec/dtazv_test.rb to have a running example of an export.

### DTA

    # create a new dtaus object
    dta = KingDta::Dtaus.new('LK')
  
    # set sender account
    dta.account = KingDta::Account.new(
                    :bank_account_number => "123456789",
                    :bank_number => "69069096",
                    :owner_name => "Return to Sender",
                    :bank_name => "Money Burner Bank")
  
    # following should be done in a loop to add multiple bookings
    # create receiving account
    receiver = KingDta::Account.new(
                    :bank_account_number => "987456123",
                    :bank_number => "99099096",
                    :owner_name => "Gimme More Lt.",
                    :bank_name => "Banking Bandits")
    # create booking
    booking = KingDta::Booking.new(receiver, 100.00 )
  
    # set booking text if you want to
    booking.text = "Thanks for your purchase"
 
    # add booking
    dta.add( booking )
    # end loop

    # create datausstring and do with it whatever fits your workflow
    my_str = dta.create

### DTAZV

    @dtazv = KingDta::Dtazv.new(Date.today)

    # sender account
    @dtazv.account = KingDta::Account.new(
      :bank_account_number => "123456789",
      :bank_number => "40050100",
      :bank_name => "Greedy Fuckers Bank",
      :owner_name => "Sender name"
    )

    # receiver account
    receiver = KingDta::Account.new(
      :bank_account_number => "987654321",
      :bank_iban => "PLsome-long-Iban",
      :bank_bic => "BicCode",
      :owner_name => "receivers name"
    )
    # add bookings, probably in a loop
    booking = KingDta::Booking.new(receiver, 220.25)
    @dtazv.add(booking)

    # get output as string
    @dtazv.create

also make sure to read the specs

## Credits

Bugfixes and enhancements by

* Georg Ledermann - https://github.com/ledermann
* Kim Rudolph - https://github.com/krudolph
* Thorsten Böttger - https://github.com/alto
* Jan Kus - https://github.com/koos

This gem used https://rubygems.org/gems/DTAUS as a starting point.
It was disected, turned into a real class structure, bugs were fixed and
of course a full test suite ensures its functionality.

Copyright (c) 2009-2011 Georg Leciejewski (SalesKing), Jan Kus (Railslove), released under the MIT license