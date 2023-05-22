# frozen_string_literal: true

require_relative './api'

module ActionView
  class Base
    include HotViewComponent::Api
  end
end
