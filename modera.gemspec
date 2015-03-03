$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'modera/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'modera'
  s.version     = Modera::VERSION
  s.authors     = ['Rankia']
  s.email       = ['rails@rankia.com']
  s.homepage    = 'https://github.com/Soluciones/Modera'
  s.summary     = 'Moderation tools.'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  s.add_dependency 'rails', '~> 4.2'

  s.add_dependency 'haml-rails'
  s.add_dependency 'sass'
  s.add_dependency 'inherited_resources'
  s.add_dependency 'jquery-rails'

  s.add_development_dependency 'pg'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-collection_matchers'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'fuubar'
end
