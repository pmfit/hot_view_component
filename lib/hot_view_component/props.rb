# frozen_string_literal: true

module HotViewComponent
  class InvalidPropError < StandardError; end
  class MissingPropError < StandardError; end

  module PropClassMethods
    def self.extended(base)
      def base.prop(name, values: [], required: false)
        define_method "#{name}_valid?" do |value|
          values.include? value
        end

        define_method "#{name}_type" do
          { values:, required: }
        end
      end
    end
  end

  module Props
    def self.included(base)
      base.extend(PropClassMethods)

      def initialize(**props)
        props.each do |prop_name, prop_value|
          prop_type = self.send("#{prop_name}_type") if self.respond_to?("#{prop_name}_type")
          next if prop_type.nil? || prop_value.nil? || !self.respond_to?("#{prop_name}_valid?")

          raise InvalidPropError, unallowed_prop_message(prop_name.to_sym, prop_value) if !responsive_prop?(prop_value) && !self.send("#{prop_name}_valid?", prop_value)

          props.each do |prop_name, prop_value|
            if responsive_prop?(prop_value)
              prop_value.each do |breakpoint, responsive_prop_value|
                raise HotViewComponent::InvalidPropError, unallowed_prop_message(prop_name.to_sym, "{ #{breakpoint}: #{responsive_prop_value} }") unless responsive_prop_value.present? && self.send("#{prop_name}_valid?", responsive_prop_value)
              end
            end
          end
        end
      end
    end

    def responsive_prop?(value)
      value.is_a?(Hash) && value[:_].present?
    end
    
    def missing_prop_message(prop_name)
      "#{prop_name} is required but was blank"
    end

    def unallowed_prop_message(prop_name, prop)
      "#{prop_name} has disallowed value: #{prop}"
    end
  end
end
