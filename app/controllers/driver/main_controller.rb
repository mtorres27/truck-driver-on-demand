# frozen_string_literal: true

class Driver::MainController < Driver::BaseController

  def index
    authorize current_user
    @jobs = Job.where(state: "published").order("created_at DESC")
  end

end
