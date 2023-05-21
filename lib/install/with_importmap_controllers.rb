gemfile_path = Rails.root.join('Gemfile')
importmap_entrypoint_path = Rails.root.join("config/importmap.rb")
application_manifest_path = Rails.root.join("app/assets/config/manifest.js")

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

if File.readlines(gemfile_path).grep(%(gem "turbo-rails")).count.positive? && File.readlines(importmap_entrypoint_path).grep(%(pin "@hotwired/turbo-rails", to: "turbo.min.js")).count.zero?
  say "Setting up Turbo"
  system! "bin/rails turbo:install"
end

unless File.readlines(importmap_entrypoint_path).grep(%(pin "@hotwired/stimulus", to: "stimulus.min.js")).count.zero?
  say "Setting up Stimulus"
  system! "bin/rails stimulus:install"
end

say "Add component controllers to asset pipeline"
inject_into_file application_manifest_path, :after => "//= link_tree ../../javascript .js" do
  "\n//= link_tree ../../components .js"
end

say "Create example hot component"
system!("bin/rails generate hot_component example_component")

say "Create component controllers entrypoint"
system!("bin/rails hot_view_component:manifest:update")

say "Pin all component controllers"
say %(Appending: pin_all_from "app/components", under: "components")
append_to_file "config/importmap.rb", %(pin_all_from "app/components"\n)
