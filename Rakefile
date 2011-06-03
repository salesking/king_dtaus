require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new

task :default => :spec

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

# require 'rdoc/task'

# desc 'Default: run specs.'
# task :default => :spec

# spec_files = Rake::FileList["spec/**/*_spec.rb"]

# desc "Run specs"
# Spec::Rake::SpecTask.new do |t|
#   t.spec_files = spec_files
#   t.spec_opts = ["-c"]
# end

# desc "Generate code coverage"
# Spec::Rake::SpecTask.new(:coverage) do |t|
#   t.spec_files = spec_files
#   t.rcov = true
#   t.rcov_opts = ['--exclude', 'spec,/var/lib/gems']
# end

# desc 'Generate documentation'
# Rake::RDocTask.new(:rdoc) do |rdoc|
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title    = 'dtaus'
#   rdoc.options << '--line-numbers' << '--inline-source'
#   rdoc.rdoc_files.include('README')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end

# begin
#   require 'jeweler'
#   Jeweler::Tasks.new do |gem|
#     gem.name = "king_dtaus"
#     gem.summary = %Q{Generate DTAUS strings and files}
#     gem.description = %Q{DTAUS is a text-based format, to create bank transfers for german banks. This gem helps with the creation of those transfer files.}
#     gem.email = "gl@salesking.eu"
#     gem.homepage = "http://github.com/salesking/king_dtaus"
#     gem.authors = ["Georg Leciejewski", "Georg Ledermann"]
#     # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
#   end
#   Jeweler::GemcutterTasks.new
# rescue LoadError
#   puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
# end