# frozen_string_literal: true

module TurboPartial
  class Railtie < ::Rails::Railtie
    initializer 'turbo_partial' do
      ActiveSupport.on_load :action_view do
        if ActionView::VERSION::MAJOR >= 6
          require_relative 'renderer'
          ActionView::Renderer.prepend TurboPartial::Renderer
        else
          require_relative 'renderer_rails5'
          ActionView::Base.prepend TurboPartial::Renderer::Rails5
          ActionView::Template.prepend TurboPartial::Template::CurrentTemplateSetter
        end

        require_relative 'template_cache'
        ActionView::Template.prepend TurboPartial::Template::TemplateCacheAppender
      end
    end
  end
end
