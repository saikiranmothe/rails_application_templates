require 'rbconfig'
require 'open-uri'

create_file '.ruby-version'
create_file '.rbenv-gemsets'
inject_into_file '.ruby-version', after: "#The code goes below this line. Don't forget the Line break at the end\n" do <<-'RUBY'
  2.0.0-p247
RUBY
end

inject_into_file '.rbenv-gemsets', after: "#The code goes below this line. Don't forget the Line break at the end\n" do <<-'RUBY'
 eshop
RUBY
end

gsub_file 'Gemfile', "gem 'jquery-rails'", "gem 'jquery-rails', '~> 2.2.1'"
gsub_file 'Gemfile', "# gem 'therubyracer', :platforms => :ruby", "gem 'therubyracer', :platforms => :ruby"
gsub_file 'Gemfile', "gem 'rails'" ," gem 'rails', '4.1.6'"

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end

#Coping Rails Logo To Admin Interface Logo
#Spree::Config[:admin_interface_logo] path
# copy_file "app/assets/images/rails.png", "app/assets/images/admin/bg/spree_50.png"

#Prawn
gem 'prawnto',:git => 'git@github.com:smecsia/prawnto.git'


#Spree Core
gem 'spree', github: 'spree/spree', branch: '2-3-stable'
gem 'spree_gateway', :git => 'https://github.com/spree/spree_gateway.git', :branch => '2-0-stable'
gem 'spree_auth_devise', github: 'spree/spree_auth_devise', branch: '2-3-stable'

# Spree Internlization Extension
#gem 'spree_i18n', :git => 'git://github.com/spree/spree_i18n.git', :branch => '2-0-stable'


#gem 'spree_invoicing  Extension'
gem 'spree_invoicing',:git => 'git@github.com:saikiranmothe/spree_invoicing_stable.git'


run 'bundle install'


####################################################
#Running Spree Generator Commands

#Installing Spree into Application  without sample data
generate 'spree:install --sample=false'


# generate 'spree_i18n:install'
# generate 'railties:install:migrations'
# generate 'db:migrate'
# generate 'db:seed'
# generate 'spree_sample:load'

initializer 'spree_config.rb', <<-CODE
   Spree::Config.currency = "INR"
   Spree::Config.site_name = "ESHOP"
   Spree::Config.default_seo_title = "eshop"
   Spree::Config.default_meta_keywords = "eshop,shop,company_name,company_slogan"
   Spree::Config.default_meta_description = "eshop ,ecommerce application"
   Spree::Config.site_url = "eshop.comapnyname.com"
   Spree::Config.currency_symbol_position  = :after
  #For Disb
CODE

generate 'spree_invoicing:install'


if yes?("Do you want to create a AdminUser (Yes/No)?")
  rake 'spree_auth:admin:create'
end

say <<-eos

################################################################

   Your new E-SHOP application is ready to go.

################################################################

eos



