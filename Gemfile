source 'http://rubygems.org'

#Rails
gem 'rails', '~> 3.2.13'


# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# Ruby Deps
platforms :ruby do
  gem 'sqlite3'
  # gem 'activerecord-postgresql-adapter'
  gem 'therubyracer'
  group :production do
    gem 'pg'
  end
  # exclude Debugger from CI
  unless ENV["CI"]
    gem 'debugger', :group => [:development, :test]
  end
end

# Forms & Upload
gem "paperclip", ">= 3.0"
gem 'formtastic'
gem "recaptcha", :require => "recaptcha/rails" #Captcha Gem

# Tool Libs
gem 'haml'
gem 'json'
gem 'enumerize', '>= 0.5.1'
gem 'will_paginate'
gem 'money-rails' # Deal with Money
gem 'state_machine' # State Machines in Rails
gem "friendly_id", ">= 4.0.9" # Friendly_id for beautiful links
gem 'awesome_nested_set' # tree structure for categories
gem 'amoeba'
gem 'sanitize' # Parser based sanitization

#gem "acts_as_paranoid", "~>0.4.0" # for softdelete
#gem "acts_as_follower" # Follow Users and Articles not used for the moment

# Indexing /Searching
gem 'sunspot_rails'

# Delayed_Jobs & Daemons
gem "daemons"
gem 'delayed_job_active_record'


# Controller Gems
gem 'devise' # authentication
gem 'inherited_resources' # dry controllers
gem "pundit" # authorization



# Deploy with Capistrano
gem 'capistrano'


# Should be only in development but else migration fails
gem 'factory_girl_rails'
gem 'faker'

#Rails Adminrails
gem 'rails_admin'

# Integrated gems
gem 'tinycms', :path => "gems/tinycms"

# Gems used only for assets and not required
# in production environments by default.
group :assets do

   # CSS
  gem 'sass-rails', '~> 3.2'
  gem 'bootstrap-sass', '~> 2.3.1.0'
  gem 'bootstrap-will_paginate'
  gem "formtastic-plus-bootstrap"
  gem "font-awesome-rails"
  gem "flatui-rails"
  gem "formtastic-plus-flatui"
  gem "susy", "~> 1.0.8"
  gem "compass", "~> 0.13.alpha.4"
  gem 'compass-rails'

  # JS
  gem 'tinymce-rails'
  gem 'tinymce-rails-langs'
  gem 'jquery-rails'
  gem 'jquery-ui-rails'
  gem 'i18n-js', :git => 'https://github.com/fnando/i18n-js.git', :branch => 'master'
  gem 'coffee-rails'
  gem 'therubyrhino'
  gem 'selectivizr-rails'
  gem 'uglifier', '>= 1.0.3'
  gem 'modernizr-rails'
  # gem 'turbolinks'
  # gem 'jquery-turbolinks'
end


# for generating *.war file
#group :development do
 # gem "warbler", "~> 1.3.2"
 # gem "jruby-rack", "~> 1.1.10"

#end

# Testing using RSpec
group :development, :test do

  # Main Test Tools
  gem 'rspec-rails'
  gem 'launchy'
  gem 'shoulda-matchers'
  gem 'capybara'
  gem "ZenTest"

  #Autotest on MAC
  gem 'autotest-fsevent' if RUBY_PLATFORM =~ /darwin/

  # Code Coverage
  gem 'simplecov'
  gem 'coveralls', require: false
  # Mutation Coverage
  # gem 'mutant-rails' ... check back to see if they got it working: https://github.com/mockdeep/mutant-rails

  #er diagramm generation
  gem "rails-erd"

   #solr gem
  gem 'sunspot_solr'
  gem "sunspot_test"

  # test suite additions
  gem "rails_best_practices"
  gem "brakeman" # security test: execute with 'brakeman'

  # Replace Webrick
  gem 'thin'

  # Notify about n+1 queries
  gem 'bullet'
end

group :development do
  # Better error messages
  gem 'better_errors'
  gem 'binding_of_caller'

  # HAML Conversion tools
  gem "erb2haml"
  gem "html2haml"

  # Clean code before commiting
  gem "code-cleaner"

  #zipruby for icecat catalog download
  gem "zipruby"

  # activerecord-import for batch-writing into the databse
  gem 'activerecord-import'
end

group :test do
  gem 'colorize'
end

# Adding Staging-server Embedded Solr
group :staging do
  gem 'sunspot_solr'
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'
