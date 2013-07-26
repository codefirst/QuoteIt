source 'https://rubygems.org'
ruby '2.0.0'

# Server requirements (defaults to WEBrick)
# gem 'thin'
# gem 'mongrel'

# Project requirements
gem 'json'
gem 'rake'
gem 'sinatra-flash', :require => 'sinatra/flash'
gem 'dalli'
gem 'oauth'
gem 'opengraph'

# Component requirements
gem 'bcrypt-ruby', :require => "bcrypt"
gem 'sass'
gem 'haml'
gem 'mongoid', '2.2.3'
gem 'bson_ext'

# Test requirements
group :development do
  gem 'rspec', :group => "test"
  gem 'rack-test', :require => "rack/test", :group => "test"
  gem 'selenium-webdriver', '2.25.0', :group => "test"
end

# Padrino Stable Gem
gem 'padrino', '0.10.5'
gem 'thin'

# Or Padrino Edge
# gem 'padrino', :git => 'git://github.com/padrino/padrino-framework.git'

# Or Individual Gems
# %w(core gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.10.5'
# end
