require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "carter"
  gem.homepage = "http://github.com/gillies-dunlop/carter"
  gem.license = "MIT"
  gem.summary = %Q{A really simple shopping cart implementation for rails.}
  gem.description = %Q{A really simple shopping cart implementation for rails.}
  gem.email = "louisgillies@ygmail.com"
  gem.authors = ["Louis Gillies"]
  gem.files =FileList['lib/**/*.rb', 'app/**/*', 'rails/*.rb', 'init.rb', 'generators/**/*.rb', 'lib/**/*.rake']
  
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  # gem.add_runtime_dependency 'money', '3.5.5'
  gem.add_runtime_dependency 'state_machine', '0.9.4'
  gem.add_development_dependency 'money', '> 3.1.5'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:features)

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
