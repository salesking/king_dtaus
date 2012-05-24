# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'king_dta/version'

Gem::Specification.new do |s|
  s.name = %q{king_dtaus}
  s.version = KingDta::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Georg Leciejewski", "Georg Ledermann", "Jan Kus"]
  s.date = %q{2011-11-15}
  s.summary = %q{Generate DTA/DTAUS and DTAZV bank transfer files .. the easy way}
  s.description = %q{DTA/DTAUS and DTAZV are text-based formats to create bank transfers for german banks.
This gem creates DTA/DATAUS files for inner german credit and debit(Gutschrift/Lastschrift) transfers.
It is also capable of creating DTAZV credit-files for transfers from Germany to European SEPA region.}
  s.email = %q{gl@salesking.eu}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.executables   = nil
  s.files         = `git ls-files`.split("\n").reject{|i| i[/^docs\//] }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")

  s.homepage = %q{http://github.com/salesking/king_dtaus}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.6.2}

  s.add_runtime_dependency 'i18n'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake', '>= 0.9.2'

end

