# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require 'rails'
require "turbo_partial"

require "minitest/autorun"
require 'byebug'

ENV['RAILS_ENV'] ||= 'test'

require_relative 'dummy_app/dummy_app'
