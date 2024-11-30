source "http://rubygems.org"

# Specify your gem's dependencies in valkyrie.gemspec
gemspec

group :development, :test do
  gem "sqlite3", :platform => [:ruby, :mswin, :mingw]
  gem "jdbc-sqlite3", :platform => :jruby
  gem 'activerecord-jdbcsqlite3-adapter', :require => ['jdbc-sqlite3', 'arjdbc'], :platform => :jruby
  gem 'factory_bot_rails', '~> 6.4', '>= 6.4.4'
  gem 'rspec', '~> 3.13'
  gem 'rspec-rails', '~> 7.1'
end