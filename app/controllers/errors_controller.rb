class ErrorsController < ApplicationController

  def not_found
    respond_to do |format|
      format.html { render status: :not_found }
    end
  rescue ActionController::UnknownFormat
    render status: :not_found
  end

end
