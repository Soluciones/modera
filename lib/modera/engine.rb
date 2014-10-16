require 'inherited_resources'
require 'haml-rails'
require 'sass'

module Modera
  class Engine < ::Rails::Engine
    isolate_namespace Modera

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine :haml
    end
  end
end
