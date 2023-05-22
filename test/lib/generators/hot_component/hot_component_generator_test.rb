require "test_helper"
require "generators/hot_component/hot_component_generator"

module HotComponent
  class HotComponentGeneratorTest < Rails::Generators::TestCase
    tests HotComponentGenerator
    destination Rails.root.join("tmp/generators")
    setup :prepare_destination

    test "generator generates a component file" do
      run_generator ["test"]

      assert_file "app/components/test_component.rb", /TestComponent < ViewComponent::Base/
    end

    test "generator generates a component stylesheet file" do
      run_generator ["test"]

      assert_file "app/components/test_component/test_component.css", /.test-component {}/
    end

    test "generator does not generate a component stylesheet file" do
      run_generator ["test", "--skip-css"]

      assert_no_file "app/components/test_component/test_component.css"
    end

    test "generator generates a component view file with a stylesheet binding" do
      run_generator ["test"]

      assert_file "app/components/test_component/test_component.html.erb", /class="test-component"/
    end

    test "generator generates a component view file with a controller binding" do
      run_generator ["test"]

      assert_file "app/components/test_component/test_component.html.erb", /data-controller="test-component"/
    end
    
    test "generator generates a component controller file" do
      run_generator ["test"]

      assert_file "app/components/test_component/test_component_controller.js", /Connects to data-controller="test-component"/
    end

    test "generator does not generate a component controller file" do
      run_generator ["test", "--skip-controller"]

      assert_no_file "app/components/test_component/test_component_controller.js"
    end
  end
end
