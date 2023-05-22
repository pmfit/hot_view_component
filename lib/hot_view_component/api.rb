# frozen_string_literal: true

module HotViewComponent
  module Api
    def method_missing(name, *args, **kwargs, &)
      if name.ends_with?('Component')
        view = args[0]

        raise ArgumentError, 'Did not pass self to View Component' if view.blank?

        begin
          component_class = Object.const_get("#{self}::#{name}".to_s)
        rescue StandardError
          component_class = Object.const_get(name.to_s)
        end

        view.render(component_class.new(**kwargs), &)
      end
    rescue StandardError => e
      raise e
    end

    def respond_to_missing?(method_name, include_private = false)
      view_class = if name.ends_with?('Component')
                     Object.const_get(method_name.to_s)
                   else
                     Object.const_get(component_name(method_name.to_s))
                   end

      view_class.present?
    rescue StandardError
      super
    end

    def component_name(name)
      # convert syntax module__componentName to ::Module::ComponentNameComponent
      module_suffix = name.to_s.split('__').map(&:camelize).join('::')
      class_suffix = module_suffix.to_s.split('_').map(&:camelize).join
      [class_suffix, 'Component'].join
    end
  end
end
