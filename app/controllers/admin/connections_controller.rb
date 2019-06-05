class Admin::ConnectionsController < Admin::BaseController

  def index
    authorize current_user
    @keywords = params.dig(:search, :keywords).presence
    @connections = Message.connections(true)

    if @keywords.present?
      @connections = @connections.select { |connection| connection.to_s.downcase.include?(@keywords.downcase) }
    end

    @connections = Kaminari.paginate_array(@connections).page(params[:page]).per(10)
  end
end
