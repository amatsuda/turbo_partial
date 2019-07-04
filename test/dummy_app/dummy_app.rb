# frozen_string_literal: true

require 'action_controller/railtie'
require 'action_view/railtie'

module TurboPartialTestApp
  Application = Class.new(Rails::Application) do
    config.eager_load = false
    config.active_support.deprecation = :log
    config.root = __dir__
  end.initialize!

  Application.routes.draw do
    resources :beers, only: :index
    namespace :admin do
      resources :beers, only: :index
    end

    resources :sushis, only: :index
  end
end

module ApplicationHelper; end

ApplicationController = Class.new ActionController::Base

Sushi = Beer = Struct.new :id

class BeersController < ApplicationController
  def index
    @beers = 10.times.map {|i| Beer.new i + 1 }
  end
end
module Admin
  class BeersController < ApplicationController
    def index
      @beers = 10.times.map {|i| Beer.new i + 1 }
    end
  end
end

class SushisController < ApplicationController
  def index
    @sushis = 10.times.map {|i| Sushi.new i + 1 }
  end
end
