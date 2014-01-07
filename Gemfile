source "http://rubygems.org"
# Add dependencies required to use your gem here.
# Example:
#   gem "activesupport", ">= 2.3.5"

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "yard", "~> 0.6.0"
  gem "cucumber"
  gem "bundler"
  gem "jeweler", "~> 2.0.0"
  gem "rcov", ">= 0"
  gem 'money', '3.1.5'
end

group :test do 
  gem "debugger"
  gem "rails", "~> 4.0.0"
  gem "shoulda-matchers"
  gem "factory_girl", "3.6.2"
  gem "state_machine"
end

group :test, :development do
  gem "sqlite3", "~> 1.3.8"
  gem "rspec", "~> 2.13.0"
end