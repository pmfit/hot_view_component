# frozen_string_literal: true

module HotViewComponent
  module PropHelper
    def prop_valid?(prop, allowed_values)
      return true if prop.blank?

      if prop.is_a?(Hash)
        checks = prop.values.map do |value|
          allowed_values.include?(value) || (value.methods.include?(:to_sym) && allowed_values.include?(value.to_sym))
        end

        return !checks.include?(false)
      end

      allowed_values.include?(prop) || (prop.methods.include?(:to_sym) && allowed_values.include?(prop.to_sym))
    end

    def disallowed_value_message(prop_name, prop)
      StandardError("#{prop_name} has disallowed value: #{prop}")
    end
  end
end
