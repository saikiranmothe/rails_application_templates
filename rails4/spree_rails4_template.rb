require 'rbconfig'
require 'open-uri'

#creating some sample files
create_file '.ruby-version'
create_file '.rbenv-gemsets'
create_file 'app/assets/logo/spree_50.png'

#insert ruby version to .ruby-version/rbenv version file
insert_into_file ".ruby-version" ,:after => "" do
  "2.0.0-p247"
end 

#insert ruby version to .ruby-version/rbenv version file
insert_into_file ".rbenv-gemsets" ,:after => "" do
  "eshop"
end 

gsub_file 'Gemfile', "# gem 'therubyracer'*", "gem 'therubyracer', :platforms => :ruby"
gsub_file 'Gemfile', "gem 'rails'*" ," gem 'rails', '4.1.6'"

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end

#Spree Core
gem 'spree', github: 'spree/spree', branch: '2-3-stable'
gem 'spree_gateway', :git => 'https://github.com/spree/spree_gateway.git', :branch => '2-3-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-3-stable'

# Spree Internlization Extension
#gem 'spree_i18n', :git => 'git://github.com/spree/spree_i18n.git', :branch => '2-0-stable'

run 'bundle install'

####################################################
#Running Spree Generator Commands


#Installing Spree into Application  without sample data
generate 'spree:install'


# generate 'spree_i18n:install'
# generate 'railties:install:migrations'
# generate 'db:migrate'
# generate 'db:seed'
# generate 'spree_sample:load'

# initializer 'spree_config.rb', <<-CODE
#    Spree::Config.currency = "INR"
#    Spree::Config.site_name = "ESHOP"
#    Spree::Config.default_seo_title = "eshop"
#    Spree::Config.default_meta_keywords = "eshop,shop,company_name,company_slogan"
#    Spree::Config.default_meta_description = "eshop ,ecommerce application"
#    Spree::Config.site_url = "eshop.comapnyname.com"
#    Spree::Config.currency_symbol_position  = :after
#   #For Disb
# CODE

run 'bundle install'


if yes?("Do you want to create an another AdminUser for Your ESHOP ( Yes / No ) ?")
  rake 'spree_auth:admin:create'
end

say <<-eos

################################################################

          Your new E-SHOP application is ready to go.

################################################################

eos



