require 'inherited_resources'
require 'haml-rails'
require 'sass'
require 'jquery-rails'

module Modera
  class Engine < ::Rails::Engine
    isolate_namespace Modera

    config.autoload_paths += Dir["#{ config.root }/lib/**/"]

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.template_engine :haml
    end

    initializer 'modera.assets.precompile' do |app|
      app.config.assets.precompile += %w(application.css)
    end
  end
end
