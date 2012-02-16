# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'
source 'http://gems.github.com'

gem "rails", "2.3.9"
gem "rake", "0.8.7"
gem "will_paginate", "~> 2.3.15"
gem "hoptoad_notifier", "2.3.2"  # Perhaps this should be in a :production group?

group :development do
  gem 'sqlite3-ruby' #     '~> 2.2.3'
end

# bundle install --without test
group :test do
  gem 'factory_girl'
  gem 'sqlite3-ruby'
  gem 'watir', "2.0.1"
end

# bundle install --without production
group :production do
  gem "pg", "0.10.0"
end
