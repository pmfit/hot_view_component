package_json = Rails.root.join("package.json")

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

unless File.readlines(importmap_entrypoint_path).grep('@hotwired/turbo-rails').present?
  say "Setting up Turbo"
  system! "bin/rails turbo:install"
end

unless File.readlines(importmap_entrypoint_path).grep('@hotwired/stimulus').present?
  say "Setting up Stimulus"
  system! "bin/rails stimulus:install"
end

say "Create component controllers entrypoint"
copy_file "#{__dir__}/app/components/index.js",
  "app/components/index.js"

say "Create example hot component"
copy_file "#{__dir__}/app/components/example_component.rb",
  "app/components/example_component.rb"
copy_file "#{__dir__}/app/components/example_component.html.rb",
  "app/components/example_component.html.rb"
copy_file "#{__dir__}/app/components/example_component_controller.js",
  "app/components/example_component_controller.js"

if (Rails.root.join("app/javascript/application.js")).exist?
  say "Import component controllers"
  append_to_file "app/javascript/application.js", %(import "../components"\n)
else
  say %(Couldn't find "app/javascript/application.js".\nYou must import "../components" in your JavaScript entrypoint file), :red
end