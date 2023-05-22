# frozen_string_literal: true

require_relative './action_view'
require_relative './api'

module HotViewComponents
  class Engine < ::Rails::Engine
    isolate_namespace HotViewComponents

    config.autoload_paths << File.expand_path('./action_view.rb', __dir__)
    config.autoload_paths << File.expand_path('./api.rb', __dir__)

    initializer "hot_view_components.modules", after: "importmap.assets" do |app|
      unless app.config.eager_load
        app.config.to_prepare do
          paths = Dir.glob(app.root.join('app/components/**/*'))
          paths.each do |path|
            app.autoloaders.main.eager_load_dir(path) if File.directory?(path)
          end

          view_components = ViewComponent::Base.descendants
          view_components.each do |component|
            module_parent = component.module_parent
            should_extend = module_parent.present? && module_parent.name.to_s != 'Object' && !module_parent.ancestors.include?(HotViewComponents::Api)
            module_parent.extend HotViewComponents::Api if should_extend
          end
        end
      end
    end

    initializer "hot_view_components.assets" do |app|
      if app.config.respond_to?(:assets)
        app.config.assets.paths << app.root.join("app/components")
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
