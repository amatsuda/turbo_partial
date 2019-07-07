# frozen_string_literal: true

module TurboPartial
  TemplateCache = Hash.new

  module Template
    module TemplateCacheAppender
      def initialize(*)
        super

        TurboPartial::TemplateCache[identifier] = self
      end
    end
  end
end
