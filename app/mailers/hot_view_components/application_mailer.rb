module Rails
  module Hotwire
    module View
      module Components
        class ApplicationMailer < ActionMailer::Base
          default from: "from@example.com"
          layout "mailer"
        end
      end
    end
  end
end
