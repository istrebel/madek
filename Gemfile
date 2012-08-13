source 'http://rubygems.org'
source 'http://gems.github.com'

gem 'rails', '3.2.6'

gem 'mysql2', '~> 0.3.8'  
gem 'pg'
gem 'memcache-client' #gem 'dalli' #gem 'redis-store'

#tmp# dependency for linecache
gem 'require_relative'

gem 'json', '~> 1.7'
gem 'haml', '~> 3.1'
gem 'sass', '~> 3.1'
gem 'coffee-script', '~> 2.2'
gem "coffee-filter", "~> 0.1.1"

#                          _             
#                         (_)            
#__      ____ _ _ __ _ __  _ _ __   __ _ 
#\ \ /\ / / _` | '__| '_ \| | '_ \ / _` |
# \ V  V / (_| | |  | | | | | | | | (_| |
#  \_/\_/ \__,_|_|  |_| |_|_|_| |_|\__, |
#                                   __/ |
#                                  |___/ 
# NOTE WARNING DO NOT CHANGE THIS LINE
gem 'jquery-rails', '= 1.0.16'
# DO NOT CHANGE, OTHERWISE ENDLESS SCROLLING STOPS WORKING (BECAUSE OF OUR INVIEW PLUGIN),
# OTHER THINGS STOP WORKING ALSO
#
gem 'rails_autolink', '~> 1.0'
gem 'jquery-tmpl-rails', '~> 1.1'
gem 'haml_assets'

# gem "d3_rails", "~> 2.9"

# Gems used only for assets and not required in production environments by default.
group :assets do
  gem 'sass-rails', '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'uglifier', '~> 1.2'
end

#tmp# gem 'cancan', '~> 1.6'

gem 'ledermann-rails-settings', :require => 'rails-settings' # alternatives: 'settingslogic', 'settler', 'rails_config', 'settings', 'simpleconfig' 

gem 'will_paginate', '~> 3.0' 

gem 'zip', '~> 2.0.2' # alternatives: 'rubyzip', 'zipruby', 'zippy'
gem 'rgl', '~> 0.4.0', :require => 'rgl/adjacency'

gem 'nested_set', '~> 1.7'
gem 'acts-as-dag', '~> 2.5.5' # TOOD use instead ?? gem 'dagnabit', '2.2.6'

gem 'net-ldap', :require => 'net/ldap'

gem 'zencoder', '~> 2.4'
gem 'uuidtools', '~> 2.1.2'
#not used anymore# gem 'mini_exiftool', '~> 1.3.1'
# gem 'mini_magick', '~> 3.3'
# gem 'streamio-ffmpeg'

gem 'irwi', :git => 'git://github.com/alno/irwi.git', :ref => 'b78694'
gem 'RedCloth'

gem 'newrelic_rpm', '~> 3.3'

gem 'nokogiri'

group :development do
  gem 'thin' # web server (Webrick do not support keep-alive connections)
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'rvm-capistrano'
  gem 'railroady'
  gem 'statsample'
end

group :test, :development do
  gem 'autotest'
  gem 'database_cleaner'
  gem 'factory_girl', '~> 3.3'
  gem 'factory_girl_rails', '~> 3.3'
  gem 'faker'
  gem 'guard', '~> 1.0'
  gem 'guard-cucumber', '~> 1.2'
  gem 'guard-rspec', '~> 1.1'
  gem 'guard-spork', '~> 1.0'
  gem 'pry'
  gem 'rb-fsevent', '~> 0.9'
  gem 'rspec-rails'
  gem 'ruby_gntp', '~> 0.3.4'
  gem 'spork'

#  Debugger works in ruby 1.9.3, however most functionality is in pry already; 
#  gem 'debugger'

# Disabling these gems because we don't do Jasmine at the moment, and loading gems makes our test startup time longer
#  gem "guard-jasmine-headless-webkit", "~> 0.3.2"
#  gem "jasmine-headless-webkit", "~> 0.8.4" # needed for "headless" running of jasmine tests (needed for CI)
#  gem "jasmine-rails", "~> 0.0.3" # javascript test environment
#  gem "jasminerice", "~> 0.0.8" # needed for implement coffeescript, fixtures and asset pipeline serverd css into jasmine

end

group :development, :production do
  gem "yard", "~> 0.8.1"
  gem "yard-rest", "~> 1.1.2"
  gem 'redcarpet' # yard-rest dependency
end

group :test do
  # gem 'cover_me' # CAUSING ERRORS FIXME
  gem 'capybara', '~> 1.1'
  gem 'cucumber', '~> 1.2'
  gem 'cucumber-rails', '~> 1.3', :require => false
  gem 'launchy'  
  gem 'selenium-webdriver', '~> 2.22'
  gem 'simplecov', '~> 0.6'
  gem 'capybara-screenshot'
end
