# frozen_string_literal: true

class ErrorsController < ApplicationController

  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
    end
  rescue ActionController::UnknownFormat
    render status: :not_found
  end

  def unauthorized
    respond_to do |format|
      format.html { render status: :unauthorized }
    end
  rescue ActionController::UnknownFormat
    render status: :unauthorized
  end

end
