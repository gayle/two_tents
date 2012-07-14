# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'
source 'http://gems.github.com'

gem "rails", "2.3.9"
gem "rake", "0.8.7"
gem "will_paginate", "~> 2.3.15"
gem "hoptoad_notifier", "2.3.2"  # Perhaps this should be in a :production group?

group :development do
  #gem "hoe", "2.12.2" # Didn't have this specified specifically before, but having trouble deploying to heroku b/c of this gem
  #    # ERROR:  Installing hoe (2.13.1) /usr/ruby1.8.7/lib/ruby/site_ruby/1.8/rubygems/installer.rb:170:in `install': hoe requires RubyGems version >= 1.4. Try 'gem update --system' to update RubyGems itself. (Gem::InstallError)
  #    # heroku config:add BUNDLE_WITHOUT="development:test"
  gem 'sqlite3-ruby' #     '~> 2.2.3'
end

# bundle install --without test
group :test do
  gem 'factory_girl'
  gem "hoe", "2.12.2" # Didn't have this specified specifically before, but having trouble deploying to heroku b/c of this gem so trying ANYTHING at this point.
      # ERROR:  Installing hoe (2.13.1) /usr/ruby1.8.7/lib/ruby/site_ruby/1.8/rubygems/installer.rb:170:in `install': hoe requires RubyGems version >= 1.4. Try 'gem update --system' to update RubyGems itself. (Gem::InstallError)
  gem 'sqlite3-ruby'
  gem 'watir' #, "2.0.1"
  gem 'ffi', '1.0.11'
end

# bundle install --without production
group :production do
  gem "pg", "0.10.0"
end
