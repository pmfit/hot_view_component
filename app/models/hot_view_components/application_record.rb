module Rails
  module Hotwire
    module View
      module Components
        class ApplicationRecord < ActiveRecord::Base
          self.abstract_class = true
        end
      end
    end
  end
end
