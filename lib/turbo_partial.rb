require "turbo_partial/version"

module TurboPartial
  class << self
    # identifier_method_name
    #"app_views_users_new_html_erb"
    # @identifier
    #"/Users/matsuda/tmp/render_include_tes/app/views/users/new.html.erb"
    # inspect
    #"app/views/users/new.html.erb"

    def compute_method_name(path)
      identifier_method_name = path.tr('^a-z_', '_')

      m = "_#{identifier_method_name}__#{Rails.root.join(path).to_s.hash}_"
      m.tr!('-', '_')
      m
    end
  end

  module ActionView
    module Renderer
      def render(context, options, &block)
        if options.key? :path
          path = options.delete :path
          full_path = if path.start_with? '/'
            'app/views' + path
          elsif path.start_with? '.'
            #TODO
          end
          full_path.sub!(/(\/)([^\/]*)$/, '/_\2')
          method_name_prefix = TurboPartial.compute_method_name full_path
          if (meth = context.methods.grep(/^#{method_name_prefix}/).first)
            context.public_send meth, options[:locals], context.output_buffer
            nil
          else
            options[:partial] = path
            super
          end
        else
          super
        end
      end
    end
  end
end

ActionView::Renderer.prepend TurboPartial::ActionView::Renderer
