require 'test_helper'

class RenderRelativeTest < ActionDispatch::IntegrationTest
  test 'render_relative (starting with ./)' do
    get '/beers'
    assert_select 'li', '🍺1'
  end

  test 'render_relative  (starting with ../)' do
    get '/admin/beers'
    assert_select 'li', '🍺1'
  end
end
