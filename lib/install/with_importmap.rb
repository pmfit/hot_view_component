js_entrypoint_path = Rails.root.join("app/javascript/application.js")
importmap_entrypoint_path = Rails.root.join("config/importmap.rb")

unless File.readlines(js_entrypoint_path).grep('import "@hotwired/turbo-rails"')
  say "Import Turbo"
  append_to_file "app/javascript/application.js", %(import "@hotwired/turbo-rails"\n)
end

unless File.readlines(importmap_entrypoint_path).grep('pin "@hotwired/turbo-rails", to: "turbo.min.js"')
  say "Pin Turbo"
  say %(Appending: pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true)
  append_to_file "config/importmap.rb", %(pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true\n)
end

unless File.readlines(js_entrypoint_path).grep('import "controllers"')
  say "Import Stimulus controllers"
  append_to_file "app/javascript/application.js", %(import "controllers"\n)
end

unless File.readlines(importmap_entrypoint_path).grep('pin "@hotwired/stimulus", to: "stimulus.min.js"')
  say "Pin Stimulus"
  say %(Appending: pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true")
  append_to_file "config/importmap.rb", %(pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true\n)
end

say "Pin all component controllers"
say %(Appending: pin_all_from "app/components", under: "components")
append_to_file "config/importmap.rb", %(pin_all_from "app/components", under: "components"\n)

say "Import Component controllers"
append_to_file "app/javascript/application.js", %(import "components"\n)