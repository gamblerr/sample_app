class ApplicationController < ActionController::Base
  require 'will_paginate/array'
  protect_from_forgery
  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
