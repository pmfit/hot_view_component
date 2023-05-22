require "minitest/autorun"
require "test_helper"
require "generators/hot_component/hot_component_generator"

describe HotViewComponent::Props do
  it 'raises a PropInvalidError when a prop is provided an unallowed value' do
    class Example
      include HotViewComponent::Props

      prop :example, values: [true, false]

      def initialize(example:)
        super
      end
    end
    
    assert_raises HotViewComponent::InvalidPropError do 
      Example.new(example: 'not allowed')
    end
  end

  it 'raises a PropInvalidError when a prop is provided an unallowed responsive value' do
    class Example
      include HotViewComponent::Props

      prop :example, values: [true, false]

      def initialize(example:)
        super
      end
    end
    
    assert_raises HotViewComponent::InvalidPropError do 
      Example.new(example: { _: 'not allowed' })
    end
  end
end
