module HotViewComponents::Manifest
  extend self

  def self.mode
    if Rails.root.join("config/importmap.rb").exist?
      :importmap
    elsif Rails.root.join("package.json").exist?
      :node
    end
  end

  def generate_from(controllers_path)
    extract_controllers_from(controllers_path).collect do |controller_path|
      if HotViewComponents::Manifest.mode === :importmap
        import_and_register_importmap_controller(controllers_path, controller_path)
      elsif HotViewComponents::Manifest.mode === :node
        import_and_register_node_controller(controllers_path, controller_path)
      end
    end
  end

  def extract_controllers_from(directory)
    (directory.children.select { |e| e.to_s =~ /_controller(\.\w+)+$/ } +
      directory.children.select(&:directory?).collect { |d| extract_controllers_from(d) }
    ).flatten.sort
  end

  def import_and_register_importmap_controller(controllers_path, controller_path)
    controller_path = controller_path.relative_path_from(controllers_path).to_s.split('.').first
    module_path_parts = controller_path.split('/')
    module_path_parts.pop
    module_path = module_path_parts.join('/')
    controller_class_name = module_path.camelize.gsub(/::/, "__")
    tag_name = module_path.remove(/_controller/).gsub(/_/, "-").gsub(/\//, "--")

    <<-JS

import #{controller_class_name} from "#{controller_path}"
application.register("#{tag_name}", #{controller_class_name})
    JS
  end

  def import_and_register_node_controller(controllers_path, controller_path)
    controller_path = controller_path.relative_path_from(controllers_path).to_s
    module_path_parts = controller_path.split('/')
    module_path_parts.pop
    module_path = module_path_parts.join('/')
    controller_class_name = module_path.camelize.gsub(/::/, "__")
    tag_name = module_path.remove(/_controller/).gsub(/_/, "-").gsub(/\//, "--")

    <<-JS

import #{controller_class_name} from "../../components/#{controller_path}"
application.register("#{tag_name}", #{controller_class_name})
    JS
  end
end