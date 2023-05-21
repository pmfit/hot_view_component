importmap_entrypoint_path = Rails.root.join("config/importmap.rb")
application_manifest_path = Rails.root.join("app/assets/config/manifest.js")

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

unless File.readlines(importmap_entrypoint_path).grep('pin "@hotwired/turbo-rails", to: "turbo.min.js"')
  say "Setting up Turbo"
  system! "bin/rails turbo:install"
end

unless File.readlines(importmap_entrypoint_path).grep('pin "@hotwired/stimulus", to: "stimulus.min.js"')
  say "Setting up Stimulus"
  system! "bin/rails stimulus:install"
end

say "Add component controllers to asset pipeline"
inject_into_file application_manifest_path, :after => "//= link_tree ../../javascript .js" do
  "\n//= link_tree ../../components .js"
end

say "Pin all component controllers"
say %(Appending: pin_all_from "app/components", under: "components")
append_to_file "config/importmap.rb", %(pin_all_from "app/components", under: "components"\n)

if (Rails.root.join("app/javascript/application.js")).exist?
  say "Import component controllers"
  append_to_file "app/javascript/application.js", %(import "components"\n)
else
  say %(Couldn't find "app/javascript/application.js".\nYou must import "components" in your JavaScript entrypoint file), :red
end
