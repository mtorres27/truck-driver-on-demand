# frozen_string_literal: true

class Driver::SettingsController < Driver::BaseController

  def index
    authorize current_user
  end

  def edit
    authorize current_user
  end

  def update
    authorize current_user
  end

end
