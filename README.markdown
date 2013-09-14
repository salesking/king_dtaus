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

* Create DTAUS debit transfer (Lastschrift)
* Create DTAUS credit transfer (Gutschrift)
* Create DTAZV debit transfer
* 100% test coverage to ensure software quality
* works with ruby 1.8 / 1.9 / 2.0

## Version Info

Version 2 has breaking changes!

* account attributes now passed in as hash
* renamed account.client_xy => owner_xy
* renamed account.account_number => bank_account_number
* added iban/bic to account
* DTAZV added

If you want to stay with v1 just pin it in your Gemfile:

    gem "king_dtaus", "<2"

## TODOs

* some more edge-case tests needed, we need your feedback here!

## Resources

* SalesKing: http://salesking.eu
* DTAZV-Viewer: http://www.meta-evolutions.de/pages/artikel-20070630-dtazv-datei-betrachter.html
* DTA/DTAZV PHP Pear: http://pear.php.net/package/Payment_DTA
* Windata ZV-Tools: http://www.windata.de/Site/2Produkte2/ZVTools.aspx
* The Swift Codes: http://www.theswiftcodes.com/
* StarMoney: http://www.starmoney.de/index.php?id=starmoneybusiness_testen

## Examples

Here are some examples how to create a DTA- or DTAZV-File. Also check out the spec/dtazv_test.rb to have a running example of an export.

### DTA

```ruby
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

```
### DTAZV

```ruby
@dtazv = KingDta::Dtazv.new()

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
```

also make sure to read the code and the specs

## Credits

Bugfixes and enhancements by

* Georg Ledermann - https://github.com/ledermann
* Kim Rudolph - https://github.com/krudolph
* Thorsten Böttger - https://github.com/alto
* Jan Kus - https://github.com/koos
* used https://rubygems.org/gems/DTAUS as a starting point

Copyright (c) 2009-2011 Georg Leciejewski (SalesKing), Jan Kus (Railslove), released under the MIT license
