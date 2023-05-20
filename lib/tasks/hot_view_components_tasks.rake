namespace :hot_view_components do
  desc "Install HotViewComponents into the app"
  task :install do
    if Rails.root.join("config/importmap.rb").exist?
      Rake::Task["hot_view_components:install:importmap"].invoke
    elsif Rails.root.join("package.json").exist?
      Rake::Task["hot_view_components:install:node"].invoke
    else
      puts "You must either be running with node (package.json) or importmap-rails (config/importmap.rb) to use this gem."
    end
  end

  namespace :install do
    desc "Install HotViewComponents into the app with asset pipeline"
    task :importmap do
      run_install_template "with_importmap"
    end

    desc "Install HotViewComponents into the app with webpacker/jsbundler"
    task :node do
      run_install_template "with_node"
    end
  end
end

def run_install_template(path)
  system "#{RbConfig.ruby} ./bin/rails app:template LOCATION=#{File.expand_path("../install/#{path}.rb", __dir__)}"
end