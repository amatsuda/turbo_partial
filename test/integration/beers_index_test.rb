require 'test_helper'

class BeersIndexTest < ActionDispatch::IntegrationTest
  test '🍻' do
    get '/beers'
    assert_select 'li', '🍺1'
  end
end
