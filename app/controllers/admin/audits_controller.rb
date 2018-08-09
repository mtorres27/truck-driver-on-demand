class Admin::AuditsController < Admin::BaseController

  def index
    authorize current_user
    @keywords = params.dig(:search, :keywords).presence
    @audits = Audit.order(created_at: :desc)
    if @keywords
      @audits = @audits.search(@keywords)
    end
    @audits = @audits.page(params[:page])
  end

end
