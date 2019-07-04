# frozen_string_literal: true

module TurboPartial
  module Template
    module CurrentTemplateSetter
      def render(view, *)
        view.current_template, current_template_was = self, view.current_template
        super
      ensure
        view.current_template = current_template_was
      end
    end
  end

  module Renderer
    module Rails5
      attr_accessor :current_template

      def render(options = {}, locals = {}, &block)
        case options
        when String
          if options.start_with?('./') || options.start_with?('../') || options.start_with?('/')
            render({partial: options, locals: locals}, locals, &block)
          else
            super
          end
        when Hash
          if (partial = options[:partial])
            # render relative (./)
            if partial.start_with? './'
              current_path = @current_template.identifier
              current_ext = current_path[/\..*/]
              partial_path = File.join(File.dirname(current_path), "_#{partial[2..-1]}#{current_ext}")

              if (partial_template = ObjectSpace.each_object(ActionView::Template).detect {|o| o.identifier == partial_path })
                partial_template.render self, options[:locals]
              else
                options[:partial] = partial[2..-1]
                super
              end

            # render relative (../)
            elsif partial.start_with? '../'
              current_path = @current_template.identifier
              current_ext = current_path[/\..*/]
              absolute_partial_path = File.expand_path partial, File.dirname(current_path)
              partial_path = "#{absolute_partial_path.sub(/\/([^\/]*)$/, '/_\1')}#{current_ext}"

              if (partial_template = ObjectSpace.each_object(ActionView::Template).detect {|o| o.identifier == partial_path })
                partial_template.render self, options[:locals]
              else
                current_view_path = view_paths.paths.detect {|vp| current_path.start_with? vp.instance_variable_get(:@path)}&.instance_variable_get(:@path)
                options[:partial] = absolute_partial_path.sub "#{current_view_path}/", ''
                super
              end

            # render absolute
            elsif partial.start_with? '/'
              current_path = @current_template.identifier
              current_view_path = view_paths.paths.detect {|vp| current_path.start_with? vp.instance_variable_get(:@path)}&.instance_variable_get(:@path)
              current_ext = current_path[/\..*/]
              partial_path = "#{current_view_path}#{partial.sub(/\/([^\/]*)$/, '/_\1')}#{current_ext}"

              if (partial_template = ObjectSpace.each_object(ActionView::Template).detect {|o| o.identifier == partial_path })
                partial_template.render self, options[:locals]
              else
                options[:partial] = partial[1..-1]
                super
              end

            else
              super
            end
          else
            super
          end
        else
          super
        end
      end
    end
  end
end
