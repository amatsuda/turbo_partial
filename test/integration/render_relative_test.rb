require 'test_helper'

class RenderRelativeTest < ActionDispatch::IntegrationTest
  test 'render_relative' do
    get '/beers'
    assert_select 'li', '🍺1'
  end
end
