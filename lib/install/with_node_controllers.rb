gemfile_path = Rails.root.join('Gemfile')
package_json_path = Rails.root.join("package.json")

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

if File.readlines(gemfile_path).grep(%(gem "turbo-rails")).count.positive? && File.readlines(package_json_path).grep(%(@hotwired/turbo-rails)).count.zero?
  say "Setting up Turbo"
  system! "bin/rails turbo:install"
end

unless File.readlines(package_json_path).grep('@hotwired/stimulus').count.zero?
  say "Setting up Stimulus"
  system! "bin/rails stimulus:install"
end

say "Create example hot component"
system!("bin/rails generate hot_component example_component")

say "Create component controllers entrypoint"
system!("bin/rails hot_view_component:manifest:update")

if (Rails.root.join("app/javascript/controllers/index.js")).exist?
  say "Import component controllers"
  append_to_file "app/javascript/controllers/index.js", %(import "./components"\n)
else
  say %(Couldn't find "app/javascript/controllers/index.js".\nYou must import "app/javascript/controllers/components" in your JavaScript entrypoint file), :red
end