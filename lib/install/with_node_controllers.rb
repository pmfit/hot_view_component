package_json_path = Rails.root.join("package.json")

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

unless File.readlines(package_json_path).grep('@hotwired/turbo-rails')
  say "Setting up Turbo"
  system! "bin/rails turbo:install"
end

unless File.readlines(package_json_path).grep('@hotwired/stimulus')
  say "Setting up Stimulus"
  system! "bin/rails stimulus:install"
end

say "Create example hot component"
system!("bin/rails generate hot_component example_component")

say "Create component controllers entrypoint"
system!("bin/rails hot_view_components:manifest:update")


if (Rails.root.join("app/javascript/application.js")).exist?
  say "Import component controllers"
  append_to_file "app/javascript/application.js", %(import "../components"\n)
else
  say %(Couldn't find "app/javascript/application.js".\nYou must import "../components" in your JavaScript entrypoint file), :red
end