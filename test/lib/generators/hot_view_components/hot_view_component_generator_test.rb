require "test_helper"
require "generators/hot_view_component/hot_view_component_generator"

module HotViewComponents
  class HotViewComponentGeneratorTest < Rails::Generators::TestCase
    tests HotViewComponentGenerator
    destination Rails.root.join("tmp/generators")
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
