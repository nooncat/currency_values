class ApplicationController < ActionController::Base
  layout 'layouts/application'

  protect_from_forgery unless: -> { request.format.json? }
end
