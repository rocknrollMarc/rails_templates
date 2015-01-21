# install gems

gem 'rails', '4.2.0'

gem 'sass-rails'
gem 'jquery-rails'
gem 'jbuilder'
gem 'uglifier'
gem 'execjs'
gem 'pg'
gem 'twitter-bootstrap-rails'

gem 'coffee-rails'


gem 'bootstrap-sass'

group :development do
  gem 'capybara'
  gem 'poltergeist'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'ffaker'

  gem 'haml'
  gem 'haml-rails'
  gem 'haml-coffee'
  gem 'haml_coffee_assets'
  gem 'coffee-filter'
end

group :development, :test do
  gem 'guard-rails'
  gem 'guard-coffeescript'
  gem 'guard-bundler'
  gem 'guard-rspec'
  gem 'guard-livereload'
  gem 'guard-spring'
  gem 'guard-rubocop'
  gem 'terminal-notifier-guard'
  gem 'ruby-growl'

  gem 'pry-rails'
  gem 'pry-nav'
  gem 'pry-doc'
  gem 'pry-coolline'
  gem 'awesome_print'

  gem 'byebug'
  gem 'web-console'

  gem 'rubocop'

  gem 'better_errors'
  gem 'quiet_assets'
  gem 'meta_request'
  gem 'binding_of_caller'
  gem 'spring'
  gem 'spring-commands-rspec'
end

gem 'devise'
gem 'activeadmin', github: 'activeadmin'
gem 'inherited_resources', github: 'josevalim/inherited_resources', branch: 'rails-4-2'

run 'bundle install'

run 'rails g rspec:install'

run 'mkdir spec/features'
run 'mkdir spec/factories'

file 'spec/rails_helper.rb', <<-CODE
  require 'capybara'
  require 'ffaker'
  require 'database_cleaner'
  require 'capybara/poltergeist'

  Capybara.javascript_driver = :poltergeist

  Rspec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.include Devise::TestHelpers

    config.before(:suite) do
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end
CODE

file 'app/config/application.rb', <<-CODE
  config.generators do |g|
    g.test_framework :rspec,
      fixtures: true,
      view_specs: false,
      helper_specs: false,
      routing_specs: false,
      controller_specs: true,
      request_specs: false
    g.fixture_replacement :factory_girl, dir: 'spec/factories'
  end
CODE

file '.rspec', <<-CODE
  --format documentation
CODE

run 'guard init'

run 'rails g active_admin:install'

rake 'db:migrate'

after_bundle do
  git :init
  git add: "."
  git commit: "-a -m 'Gem, activeadmin, capybara, factory_girl, rspec setup'"
end


