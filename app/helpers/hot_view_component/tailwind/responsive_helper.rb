# frozen_string_literal: true
module HotViewComponent
  module Tailwind
    DEFAULT_BREAKPOINTS = {
      _: 'mobile',
      sm: '640px',
      md: '768px',
      lg: '1024px',
      xl: '1280px',
      '2xl': '1536px'
    }.freeze

    module ClassMethods
      def self.breakpoints(breakpoints)
        define_method :defined_breakpoints do
          breakpoints
        end
      end
    end

    module ResponsiveHelper
      # NOTE: if you change tailwind's breakpoints this will EXPLODE


      def self.included(base)
        base.extend(HotViewComponent::Tailwind::ClassMethods)

        def breakpoints
          HotViewComponent::Tailwind::DEFAULT_BREAKPOINTS
        end
      end

      def responsive_classes(prop, classes = nil, &block)
        return '' if prop.blank?

        if block.is_a? Proc
          classes_for_breakpoint = breakpoints.keys.each_with_object({}) do |breakpoint, breakpoints|
            breakpoint_classes = block.call(breakpoint.to_sym)

            next unless breakpoint_classes.present?

            breakpoints[breakpoint] = breakpoint_classes 
          end

          resolved_classes = classes_for_breakpoint.keys.map do |breakpoint|
            classes = classes_for_breakpoint[breakpoint]

            next if classes.blank?

            responsive_classes_for_prop(prop, classes)
          end

          return '' if resolved_classes.blank?

          return resolved_classes.uniq.join(' ')
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
end
