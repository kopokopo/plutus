source 'http://rubygems.org'

# Specify your gem's dependencies in plutus.gemspec
gemspec

group :development, :test do
  gem 'activerecord-jdbcsqlite3-adapter', '~> 51.0', require: %w[jdbc-sqlite3 arjdbc], platform: :jruby
  gem 'factory_bot_rails', '~> 6.5', '>= 6.5.1'
  gem 'jdbc-sqlite3', '~> 3.46', '>= 3.46.1.1', platform: :jruby
  gem 'rspec', '~> 3.4'
  gem 'rspec-rails', '~> 8.0', '>= 8.0.1'
  gem 'sqlite3', '~> 2.8', platform: %i[ruby mswin mingw]
end

