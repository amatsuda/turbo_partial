# frozen_string_literal: true

module TurboPartial
  module RelativeRenderer
    def render_partial(context, options, &block)
      partial = options[:partial]

      # render relative (./)
      if partial.start_with? './'
        current_template = context.instance_variable_get :@current_template
        current_path = current_template.identifier
        current_ext = current_path[/\..*/]
        partial_path = File.join(File.dirname(current_path), "_#{partial[2..-1]}#{current_ext}")

        if (partial_template = ObjectSpace.each_object(ActionView::Template).detect {|o| o.identifier == partial_path })
          partial_template.render context, options[:locals]
        else
          options[:partial] = partial[2..-1]
          super
        end

      # render relative (../)
      elsif partial.start_with? '../'
        current_template = context.instance_variable_get :@current_template
        current_path = current_template.identifier
        current_ext = current_path[/\..*/]
        absolute_partial_path = File.expand_path partial, File.dirname(current_path)
        partial_path = "#{absolute_partial_path.sub(/\/([^\/]*)$/, '/_\1')}#{current_ext}"

        if (partial_template = ObjectSpace.each_object(ActionView::Template).detect {|o| o.identifier == partial_path })
          partial_template.render context, options[:locals]
        else
          current_view_path = context.view_paths.paths.detect {|vp| current_path.start_with? vp.path}&.path
          options[:partial] = absolute_partial_path.sub "#{current_view_path}/", ''
          super
        end

      # render absolute
      elsif partial.start_with? '/'
        current_template = context.instance_variable_get :@current_template
        current_path = current_template.identifier
        current_view_path = context.view_paths.paths.detect {|vp| current_path.start_with? vp.path}&.path
        current_ext = current_path[/\..*/]
        partial_path = "#{current_view_path}#{partial.sub(/\/([^\/]*)$/, '/_\1')}#{current_ext}"

        if (partial_template = ObjectSpace.each_object(ActionView::Template).detect {|o| o.identifier == partial_path })
          partial_template.render context, options[:locals]
        else
          options[:partial] = partial[1..-1]
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
