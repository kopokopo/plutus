
# -*- encoding: utf-8 -*-

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require 'plutus/version'
require 'date'

Gem::Specification.new do |s|
  s.name = %q{plutus}
  s.version = Plutus::VERSION

  s.authors = ['Michael Bulat','Dennis Ondeng']
  s.date = Date.today
  s.description = %q{The plutus plugin provides a complete double entry accounting system for use in any Ruby on Rails application. The plugin follows general Double Entry Bookkeeping practices. All calculations are done using BigDecimal in order to prevent floating point rounding errors. The plugin requires a decimal type on your database as well.}
  s.email = %q{mbulat@crazydogsoftware.com}
  s.extra_rdoc_files =  %w(LICENSE README.markdown)

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if s.respond_to?(:metadata)
    s.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end


  s.add_dependency('rails', '~> 4.0.0')

  s.add_development_dependency('yard')
  s.add_development_dependency 'bundler', '~> 1.10'
  s.add_development_dependency 'rake', '~> 10.0'
  s.add_development_dependency 'rspec'

  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  s.homepage = %q{https://github.com/dondeng/plutus.git}
  s.require_paths = ['lib']
  s.required_rubygems_version = '>= 1.3.6'
  s.summary = %q{A Plugin providing a Double Entry Accounting Engine for Rails}
  s.test_files = Dir['{spec}/**/*']

  # if s.respond_to? :specification_version then
  #   s.specification_version = 3
  #   if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
  #   else
  #   end
  # else
  # end
end
