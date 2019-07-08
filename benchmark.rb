# frozen_string_literal: true

require 'rails'
require 'byebug'
require 'turbo_partial'
require 'action_view'
require 'action_view/railtie'
require 'action_view/base'

ENV['RAILS_ENV'] = 'production'

require_relative 'test/dummy_app/dummy_app'

benchmark = case ARGV[0]
when 'time'
  ->(&b) { now = Time.now; b.call; Time.now - now }
when 'methods'
  ->(&b) do
    [].tap do |methods|
      TracePoint.new(:call) {|t| methods << "#{t.defined_class}##{t.method_id}" }.enable { b.call }
    end.tally
  end
else
  ->(&b) { MemoryProfiler.report(&b) }
end


GC.start

def view
  @view ||= begin
    path = ActionView::FileSystemResolver.new('test/dummy_app/app/views')
    view_paths = ActionView::PathSet.new([path])
    view = ActionView::Base.with_empty_template_cache
    view.with_view_paths(view_paths)
  end
end

p view.render template: 'bench/show'
