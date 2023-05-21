# frozen_string_literal: true

require_relative './action_view'

module HotViewComponents
  class Engine < ::Rails::Engine
    isolate_namespace HotViewComponents

    config.autoload_paths << File.expand_path('./action_view.rb', __dir__)
    config.autoload_paths << File.expand_path('./api.rb', __dir__)

    initializer "hot_view_components.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << Rails.root.join("app/components")
      end
    end

    initializer "hot_view_components.importmap", after: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths = [*app.config.importmap.paths, Engine.root.join("config/importmap.rb")]
      end
    end

    initializer "hot_view_components.importmap.assets", after: "importmap.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << Rails.root.join("app/components")
      end
    end
  end
end
