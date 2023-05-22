# frozen_string_ltesteral: true

require 'test_helper'

module HotViewComponent::Tailwind
  class ResponsiveHelperTest < ActionView::TestCase
    test 'returns the class matching the prop value when the prop is a string' do
      classes = { foo: { _: 'bar' } }
      prop = :foo

      assert_equal(responsive_classes(prop, classes), 'bar')
    end

    test 'returns the class matching the prop value when the prop is a boolean' do
      classes = { true => { _: 'bar' } }
      prop = true

      assert_equal(responsive_classes(prop, classes), 'bar')
    end

    test 'returns the class matching the prop value when the prop is a number' do
      classes = { 0 => { _: 'bar' } }
      prop = 0

      assert_equal(responsive_classes(prop, classes), 'bar')
    end

    test 'returns all of the responsive classes matching the prop values when the prop is a responsive hash' do
      classes = {
        foo: { _: 'bar', sm: 'sm:bar', md: 'md:bar', lg: 'lg:bar', xl: 'xl:bar', '2xl': '2xl:bar' },
        bar: { _: 'foo', sm: 'sm:foo', md: 'md:foo', lg: 'lg:foo', xl: 'xl:foo', '2xl': '2xl:foo' }
      }
      prop = { _: :foo, sm: :bar, md: :foo, lg: :bar, xl: :foo, '2xl': :bar }

      assert_equal(responsive_classes(prop, classes), %w[bar sm:foo md:bar lg:foo xl:bar 2xl:foo])
    end

    test 'returns all of the responsive classes matching the cross-section of two props when passed a lambda' do
      classes = {
        top: { _: 'center', sm: 'sm:center', md: 'md:center', lg: 'lg:center', xl: 'xl:center', '2xl': '2xl:center' },
        left: { _: 'left', sm: 'sm:left', md: 'md:left', lg: 'lg:left', xl: 'xl:left', '2xl': '2xl:left' }
      }
      align_for_direction_classes = {
        vertical: classes,
        horizontal: classes
      }
      props = { align: :top, direction: :vertical }
      result = responsive_classes(props[:align]) do |breakpoint|
        current_direction = props[:direction].is_a?(Hash) ? props[:direction][breakpoint] : props[:direction]

        return if current_direction.blank?

        breakpoint_classes = align_for_direction_classes[current_direction]

        return if breakpoint_classes.blank?

        breakpoint_classes
      end

      assert_equal(result, 'center')
    end

    test 'returns all of the responsive classes matching the cross-section of two responsive props when passed a lambda' do
      classes = {
        top: { _: 'center', sm: 'sm:center', md: 'md:center', lg: 'lg:center', xl: 'xl:center', '2xl': '2xl:center' },
        left: { _: 'left', sm: 'sm:left', md: 'md:left', lg: 'lg:left', xl: 'xl:left', '2xl': '2xl:left' }
      }
      align_for_direction_classes = {
        vertical: classes,
        horizontal: classes
      }
      props = { align: { _: :top, sm: :top }, direction: { _: :vertical, sm: :horizontal } }
      result = responsive_classes(props[:align]) do |breakpoint|
        current_direction = props[:direction].is_a?(Hash) ? props[:direction][breakpoint] : props[:direction]

        return if current_direction.blank?

        breakpoint_classes = align_for_direction_classes[current_direction]

        return if breakpoint_classes.blank?

        breakpoint_classes[breakpoint]
      end

      assert_equal(result, "center sm:left")
    end
  end
end
