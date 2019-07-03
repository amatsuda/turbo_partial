module TurboPartial
  module RelativeRenderer
    def render_partial(context, options, &block)
      partial = options[:partial]

      if partial.start_with? './'
        current_template = context.instance_variable_get :@current_template
        current_path = current_template.identifier
        partial_path = File.join(File.dirname(current_path), "_#{partial[2..-1]}#{current_path[/\..*/]}")

        if (partial_template = ObjectSpace.each_object(ActionView::Template).detect {|o| o.identifier == partial_path })
          partial_template.render context, options[:locals]
        else
          options[:partial] = partial[2..-1]
          super
        end
      else
        super
      end
    end
  end

  class Railtie < ::Rails::Railtie
    initializer 'turbo_partial' do
      ActiveSupport.on_load :action_view do
        ActionView::Renderer.prepend TurboPartial::RelativeRenderer
      end
    end
  end
end
