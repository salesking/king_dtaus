require 'rake'
require 'rspec'
require 'rspec/core/rake_task'
require 'rdoc/task'
require 'bundler/gem_helper'
Bundler::GemHelper.install_tasks
desc "Run specs"
RSpec::Core::RakeTask.new

task :default => :spec

RSpec::Core::RakeTask.new(:coverage) do |t|
  t.rcov = true
  t.rcov_opts =  %q[--exclude "spec"]
  t.verbose = true
end

desc 'Generate documentation'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'docs/rdoc'
  rdoc.title    = 'KingPdf'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end