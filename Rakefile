require 'rake'
require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new

task :default => :spec

RSpec::Core::RakeTask.new(:coverage) do |t|
  t.rcov = true
  t.rcov_opts =  %q[--exclude "spec"]
  t.verbose = true
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "king_dtaus"
    gem.summary = %Q{Generate DTAUS strings and files}
    gem.description = %Q{DTAUS is a text-based format, to create bank transfers for german banks. This gem helps with the creation of those transfer files.}
    gem.email = "gl@salesking.eu"
    gem.homepage = "http://github.com/salesking/king_dtaus"
    gem.authors = ["Georg Leciejewski", "Georg Ledermann", "Jan Kus"]
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end