# frozen_string_literal: true

module HotViewComponent
  module PreviewHelper
    def preview_frame(preview_name, **attrs)
      turbo_frame_tag(preview_name.gsub('/', '_'), src: "/design-system/previews/#{preview_name}", **attrs) do
        'Loading...'
      end
    end
  end
end
