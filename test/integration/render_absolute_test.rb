# frozen_string_literal: true

require 'test_helper'

class RenderAbsoluteTest < ActionDispatch::IntegrationTest
  test 'render_absolute' do
    get '/sushis'
    assert_select 'li', '🍣1'
  end
end
