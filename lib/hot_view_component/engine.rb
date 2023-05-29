# frozen_string_literal: true

require 'view_component'
require_relative './action_view'
require_relative './api'

module HotViewComponent
  class Engine < ::Rails::Engine
    isolate_namespace HotViewComponent

    config.autoload_paths << File.expand_path('./action_view.rb', __dir__)
    config.autoload_paths << File.expand_path('./api.rb', __dir__)

    initializer "hot_view_component.modules", after: "importmap.assets" do |app|
      app.config.after_initialize do
        app.autoloaders.main.on_setup do
          paths = Dir.glob(app.root.join('app/components/**/*.rb'))

          paths.each do |path|
            app.autoloaders.main.load_file(path)
          end

          view_components = ::ViewComponent::Base.descendants
          view_components.each do |component|
            module_parent = component.module_parent
            should_extend = module_parent.present? && module_parent.name.to_s != 'Object' && !module_parent.ancestors.include?(HotViewComponent::Api)
            module_parent.extend HotViewComponent::Api if should_extend
          end
        end
      end
    end

    initializer "hot_view_component.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << app.root.join("app/components")
      end
    end

    initializer "hot_view_component.importmap", after: "importmap" do |app|
      if app.config.respond_to?(:importmap)
        app.config.importmap.paths = [*app.config.importmap.paths, Engine.root.join("config/importmap.rb")]
      end
    end

    initializer "hot_view_component.importmap.assets", after: "importmap.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << Rails.root.join("app/components")
      end
    end
  end
end
