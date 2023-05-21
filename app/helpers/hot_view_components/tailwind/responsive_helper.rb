# frozen_string_literal: true
module HotViewComponent::Tailwind
  module ResponsiveHelper
    # NOTE: if you change tailwind's breakpoints this will EXPLODE
    BREAKPOINTS = {
      _: 'mobile',
      sm: '640px',
      md: '768px',
      lg: '1024px',
      xl: '1280px',
      '2xl': '1536px'
    }.freeze

    def responsive_classes(prop, classes, get_classes_for_breakpoint = nil)
      return '' if prop.blank? || classes.blank?

      if get_classes_for_breakpoint.present? && get_classes_for_breakpoint.respond_to?(:call)
        classes_for_breakpoint = BREAKPOINTS.keys.each_with_object({}) do |breakpoint, breakpoints|
          breakpoint_classes = get_classes_for_breakpoint.call(breakpoint)

          breakpoints[breakpoint] = breakpoint_classes if breakpoint_classes
        end

        resolved_classes = classes_for_breakpoint.keys.map do |breakpoint|
          classes = classes_for_breakpoint[breakpoint]

          return '' if classes.blank?

          responsive_classes_for_prop(prop, classes)
        end

        return '' if resolved_classes.blank?

        resolved_classes.filter do |value, i|
          resolved_classes.find_index(value) == i
        end
      end

      responsive_classes_for_prop(prop, classes)
    end

    private

    def responsive_classes_for_prop(prop, classes)
      if prop.is_a?(Hash)
        prop.keys.map do |breakpoint|
          breakpoint_value = prop[breakpoint]

          return '' if breakpoint_value.blank?

          breakpoint_classes = classes[breakpoint_value]

          return '' if breakpoint_classes.blank?

          breakpoint_classes[breakpoint]
        end
      elsif [true, false].include?(prop)
        classes_for_prop = classes[prop]

        return '' if classes_for_prop.blank?

        classes_for_prop[:_]
      else
        classes_for_prop = classes[prop]

        return '' if classes_for_prop.blank?

        classes_for_prop[:_]
      end
    end
  end
end
