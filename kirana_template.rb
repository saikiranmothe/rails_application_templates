require 'rbconfig'

gsub_file 'Gemfile', "gem 'jquery-rails'", "gem 'jquery-rails', '~> 2.2.1'"
gsub_file 'Gemfile', "# gem 'therubyracer', :platforms => :ruby", "gem 'therubyracer', :platforms => :ruby"

if File.read("#{destination_root}/Gemfile") !~ /assets.+coffee-rails/m
  gem "coffee-rails", :group => :assets
end


#Coping Rails Logo To Admin Interface Logo
#Spree::Config[:admin_interface_logo] path
copy_file "app/assets/images/rails.png", "app/assets/images/admin/bg/spree_50.png"



#Prawn
gem 'prawnto',:git => 'git@github.com:smecsia/prawnto.git'

# Spree Internlization Extension
gem 'spree_i18n', :git => 'git://github.com/spree/spree_i18n.git', :branch => '2-0-stable'

#Spree Core
gem 'spree', '2.0.1'
gem 'spree_gateway', :git => 'https://github.com/spree/spree_gateway.git', :branch => '2-0-stable'
gem 'spree_auth_devise', :git => 'https://github.com/spree/spree_auth_devise.git', :branch => '2-0-stable'

#gem 'spree_invoicing  Extension'
#gem 'spree_invoicing',:git => "https://github.com/saikiranmothe/spree_invoicing.git"
# gem 'spree_invoicing',:path => '/home/sai.kiran/Projects'
#gsub_file 'Gemfile', /#.*\n/, "\n"
gem 'spree_invoicing' ,:git => "git@gitlab.partheas.net:kirana/spree_invoicing.git"

run 'bundle install'

run 'HTTP_PROXY="http://10.0.0.22:8888" bundle install'


#Running Spree Generator Commands

#Installing Spree into Application  without sample data
generate 'spree:install --sample=false'


generate 'spree_i18n:install'

initializer 'spree_il8n.rb', <<-CODE
   SpreeI18n::Config.available_locales = [:en,:fr,:de]
   SpreeI18n::Config.supported_locales = [:en,:fr,:de]
CODE

=begin
append_file 'config/initializers/spree.rb' do
  ' SpreeI18n::Config.available_locales = [:en,:fr,:de]'
end
append_file 'config/initializers/spree.rb' do
  ' SpreeI18n::Config.supported_locales = [:en,:fr,:de]'
end
#append 'config/initializers/spree.rb', "SpreeI18n::Config.available_locales = [:en,:fr,:de]"
#append 'config/initializers/spree.rb',  " SpreeI18n::Config.supported_locales  = [:en,:fr,:de]"
=end


if yes?("Do you want to create Spree admin (Yes/No)?")
  rake "kirana_admin:create"
end

generate 'spree_invoicing:install'


say <<-eos

################################################################
   Your new Kirana application is ready to go.

eos



