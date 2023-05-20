# frozen_string_literal: true

require_relative './api'

module ActionView
  class Base
    include HotViewComponents::Api
  end
end
