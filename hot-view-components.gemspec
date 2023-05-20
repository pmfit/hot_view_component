require_relative "lib/hot_view_components/version"

Gem::Specification.new do |spec|
  spec.name        = "hot_view_components"
  spec.version     = HotViewComponents::VERSION
  spec.authors     = ["chrisdmacrae", "ncphillips"]
  spec.email       = ["contact@pmfit.org"]
  spec.homepage    = "https://github.com/pmfit"
  spec.summary     = "A ruby gem to tightly integrate View Components with Hotwire and Rails"
  spec.description = "A ruby gem to tightly integrate View Components with Hotwire and Rails"
    spec.license     = "MIT"
  
  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/pmfit/hot-view-components"
  spec.metadata["changelog_uri"] = "https://github.com/pmfit/hot-view-components/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.required_ruby_version = ">= 2.7.0"
  spec.add_dependency "rails", ">= 7.0.4.3"
  spec.add_dependency 'view_component', '~> 3.0'
end
