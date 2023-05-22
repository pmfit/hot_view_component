require "rails/generators/named_base"

class HotComponentGenerator < Rails::Generators::NamedBase # :nodoc:
  source_root File.expand_path("templates", __dir__)

  desc "Generates a Hot ViewComponent"
  argument :name, type: :string, banner: "[module/component_name]"
  class_option :tailwind, type: :boolean, default: false
  class_option :'skip-controller', type: :boolean, default: false
  class_option :'skip-css', type: :boolean, default: false

  def copy_view_files
    @component_name = component_name
    @controller_name = controller_name
    @module_name = component_module
    @class_name = component_class

    if options[:tailwind]
      template "tailwind/component.rb", "app/components/#{component_name}_component.rb"
      template "tailwind/view.html.erb", "app/components/#{component_name}_component/#{component_name}_component.html.erb"
      template "tailwind/controller.js", "app/components/#{component_name}_component/#{component_name}_component_controller.js" unless options[:'skip-controller']
    else
      template "component.rb", "app/components/#{component_name}_component.rb"
      template "view.html.erb", "app/components/#{component_name}_component/#{component_name}_component.html.erb"
      template "stylesheet.css", "app/components/#{component_name}_component/#{component_name}_component.css" unless options[:'skip-css']
      template "controller.js", "app/components/#{component_name}_component/#{component_name}_component_controller.js" unless options[:'skip-controller']
    end

    # We need to update the stimulus manifest if running in node context (js-bundler or webpacker)
    rails_command "hot_view_component:manifest:update" unless Rails.root.join("config/importmap.rb").exist?
  end

  private
  def component_name
    name.underscore.gsub(/_component$/, "")
  end

  def component_module
    parts = component_name.split("/")

    # Dump the class name
    parts.pop

    parts.map(&:titleize).join("::")
  end

  def component_class
    parts = component_name.split("/")
    
    parts.pop.titleize
  end

  def controller_name
    component_name.gsub(/\//, "--").gsub("_", "-")
  end
end