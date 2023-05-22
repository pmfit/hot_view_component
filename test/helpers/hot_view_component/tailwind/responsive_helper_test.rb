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
      a_classes = {
        foo: { _: 'bar', sm: 'sm:bar', md: 'md:bar', lg: 'lg:bar', xl: 'xl:bar', '2xl': '2xl:bar' }
      }
      a_for_bar_classes = {
        bar: a_classes[:foo]
      }
      props = { foo: :foo, bar: :bar }

      assert_equal(
        responsive_classes(props[:foo], a_classes, lambda do |_|
            current_bar = props[:bar]
            current_classes = a_for_bar_classes[current_bar]

            current_classes[props[:foo]]
          end),
        false)
    end

    test 'returns all of the responsive classes matching the cross-section of two responsive props when passed a lambda' do
      a_classes = {
        foo: { _: 'bar', sm: 'sm:bar', md: 'md:bar', lg: 'lg:bar', xl: 'xl:bar', '2xl': '2xl:bar' }
      }
      a_for_bar_classes = {
        bar: a_classes[:foo]
      }
      props = { foo: { _: :foo, sm: :foo }, bar: { _: :bar, sm: :bar} }

      assert_equal(responsive_classes(props[:foo], a_classes, lambda do |breakpoint|
        current_bar = props[:bar][breakpoint]

        return if current_bar.blank?

        current_classes = a_for_bar_classes[current_bar]

        return if current_classes.blank?

        current_classes[props[:foo]]
      end), false)
    end
  end
end
