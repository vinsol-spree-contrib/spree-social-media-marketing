# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_social_media_marketing'
  s.version     = '3.1.0'
  s.summary     = 'This gem is to automatically advertise on social media about new products, promotions and milestones.'
  s.description = 'Use this gem to add social media account to the store and automatically post about any new products, promotions, and milestones.'
  s.required_ruby_version = '>= 2.1.0'

  s.author    = 'Vinsol'
  s.email     = 'info@vinsol.com'
  # s.homepage  = 'http://www.spreecommerce.com'
  s.license = 'BSD-3'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  spree_version = '~> 3.1.0'

  s.add_dependency 'spree_core', spree_version

  s.add_runtime_dependency 'omniauth', '~> 1.8.1'
  s.add_runtime_dependency 'oa-core'
  s.add_runtime_dependency 'twitter', '~> 5.15.0'
  s.add_runtime_dependency 'omniauth-twitter', '~> 1.4.0'
  s.add_runtime_dependency 'koala'
  s.add_runtime_dependency 'omniauth-facebook', '~> 4.0.0'

  s.add_development_dependency 'capybara', '~> 2.6'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 3.4'
  s.add_development_dependency 'sass-rails', '~> 5.0.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
