# frozen_string_literal: true

module TurboPartial
  class Railtie < ::Rails::Railtie
    initializer 'turbo_partial' do
      ActiveSupport.on_load :action_view do
        if ActionView::VERSION::MAJOR >= 6
          require_relative 'renderer'
          ActionView::Renderer.prepend TurboPartial::Renderer
        end
      end
    end
  end
end
