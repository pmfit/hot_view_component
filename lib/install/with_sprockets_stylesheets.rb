application_css_path = Rails.root.join("app/assets/stylesheets/application.css")

if (application_css_path).exist?
  say "Require component stylesheets"
  inject_into_file application_css_path, :after => "*= require_tree ." do
    "\n *= require_tree ../../components"
  end
else
  say %(Couldn't find "app/assets/stylesheets/application.css".\nSomething is very wrong!), :red
end