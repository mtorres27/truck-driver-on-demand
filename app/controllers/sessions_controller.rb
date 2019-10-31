# frozen_string_literal: true

class SessionsController < Devise::SessionsController

  def new
    super
  end

  def create
    reset_session
    super
  end

  def destroy
    super
  end

end
