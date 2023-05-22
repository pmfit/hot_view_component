require 'hot_view_component/manifest'

namespace :hot_view_component do
  desc "Install HotViewComponent into the app"
  task :install do
    if File.readlines(Rails.application.root.join('Gemfile')).grep(/gem ["|']view_component["|']/).count.zero?
      puts %(
        HotViewComponent extends the ViewComponent gem. 
        
        Run "bin/bundle add view_component" and re-run this installer.
      ).split("\n").map(&:lstrip).join("\n")
    elsif File.readlines(Rails.application.root.join('Gemfile')).grep(/gem ["|']stimulus-rails["|']/).count.zero?
      puts %(
        Hot view components extends the stimulus-rails gem. 
        
        Run bin/bundle add stimulus-rails and re-run this installer."
      ).split("\n").map(&:lstrip).join("\n")
    else
      if Rails.root.join("config/importmap.rb").exist?
        Rake::Task["hot_view_component:install:importmap"].invoke
      elsif Rails.root.join("package.json").exist?
        Rake::Task["hot_view_component:install:node"].invoke
      else
        puts "You must either be running with node (package.json) or importmap-rails (config/importmap.rb) to use this gem."
      end
    end
  end

  namespace :install do
    desc "Install HotViewComponent into the app with asset pipeline"
    task :importmap do
      run_install_template "with_importmap_controllers"
      run_install_template "with_sprockets_stylesheets"
    end

    desc "Install HotViewComponent into the app with node"
    task :node do
      run_install_template "with_node_controllers"
      run_install_template "with_sprockets_stylesheets"
    end
  end

  namespace :manifest do
    task :display do
      puts HotViewComponent::Manifest.generate_from(Rails.root.join("app/components"))
    end

    task :update do
      manifest =
        HotViewComponent::Manifest.generate_from(Rails.root.join("app/components"))

      File.open(Rails.root.join("app/javascript/controllers/components.js"), "w+") do |index|
        index.puts "// This file is auto-generated by ./bin/rails hot_view_component:manifest:update"
        index.puts "// Run that command whenever you add a new controller or create them with"
        index.puts "// ./bin/rails generate hot_view_component component_name"
        index.puts
        index.puts %(import { application } from "controllers/application") if HotViewComponent::Manifest.mode === :importmap
        index.puts %(import { application } from "./application") if HotViewComponent::Manifest.mode === :node
        index.puts manifest
      end
    end
  end
end

def run_install_template(path)
  system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/#{path}.rb", __dir__)}"
end