# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'
source 'http://gems.github.com'
#source 'http://rubygems.org'
#source 'https://rubygems.org'

gem "rails", "~> 3.2.0"
gem "rake", "10.1.0" #, "0.8.7"
gem "will_paginate", "3.0.4" #, "~> 2.3.15"
gem "airbrake", "3.1.14" #, "2.3.2"  # Perhaps this should be in a :production group?
gem 'pg', "0.16.0" #, '0.14.1'
gem 'win32-process', "0.6.6" #, "0.6.5", :platforms => [:mswin, :mingw]
gem "win32-open3", "0.3.2", :platforms => [:mswin, :mingw]
gem 'json'
#gem 'jquery-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development do
  #gem "hoe", "2.12.2" # Didn't have this specified specifically before, but having trouble deploying to heroku b/c of this gem
  #    # ERROR:  Installing hoe (2.13.1) /usr/ruby1.8.7/lib/ruby/site_ruby/1.8/rubygems/installer.rb:170:in `install': hoe requires RubyGems version >= 1.4. Try 'gem update --system' to update RubyGems itself. (Gem::InstallError)
  #    # heroku config:add BUNDLE_WITHOUT="development:test"
  gem 'pry', "~> 0.9.12"
end

# bundle install --without test
group :test do
  gem 'factory_girl', "~> 2.6.0"
  #gem "hoe" #, "2.12.2" # Didn't have this specified specifically before, but having trouble deploying to heroku b/c of this gem so trying ANYTHING at this point.
  #    # ERROR:  Installing hoe (2.13.1) /usr/ruby1.8.7/lib/ruby/site_ruby/1.8/rubygems/installer.rb:170:in `install': hoe requires RubyGems version >= 1.4. Try 'gem update --system' to update RubyGems itself. (Gem::InstallError)
  #gem 'watir' #, "2.0.1"
  gem 'ffi', "1.9.0" #, '1.0.11'
end

# bundle install --without production
group :production do
end
