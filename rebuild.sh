#!/bin/bash
gem uninstall king_dtaus
rm -rf ./king_dtaus-*.gem
gem build king_dtaus.gemspec
gem install king_dtaus --local ./king_dtaus-*.gem --no-ri --no-rdoc
