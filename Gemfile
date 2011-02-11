# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'  
source 'http://gems.github.com'

gem "rails", "2.3.5"
gem "mislav-will_paginate", "2.3.11", :require => 'will_paginate'
gem "hoptoad_notifier", "2.3.2"  # Perhaps this should be in a :production group?

group :development do
  gem 'sqlite3-ruby' #     '~> 2.2.3'
end

# bundle install --without test
group :test do
  gem 'factory_girl'
  gem 'sqlite3-ruby' 
end

group :production do
  gem "pg"
end