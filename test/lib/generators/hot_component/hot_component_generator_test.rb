require "test_helper"
require "generators/hot_component/hot_component_generator"

module HotComponent
  class HotComponentGeneratorTest < Rails::Generators::TestCase
    tests HotComponentGenerator
    destination Rails.root.join("tmp/generators")
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
