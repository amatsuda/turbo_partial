# frozen_string_literal: true

module TurboPartial
  class Railtie < ::Rails::Railtie
    initializer 'turbo_partial' do
      ActiveSupport.on_load :action_view do
        ActionView::Renderer.prepend TurboPartial::RelativeRenderer
      end
    end
  end
end
