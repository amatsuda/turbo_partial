# frozen_string_literal: true

module TurboPartial
  TemplateCache = Hash.new

  module Template
    module TemplateCacher
      def initialize(*)
        super

        TurboPartial::TemplateCache[identifier] = self
      end
    end
  end
end
