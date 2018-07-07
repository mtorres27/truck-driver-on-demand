class Admin::PagesController < Admin::BaseController
  before_action :set_page, only: [:edit, :update]
  before_action :authorize_page, only: [:edit, :update]

  def index
    authorize current_user
    @pages = Page.order(:title)
  end

  def edit
  end

  def update
    if @page.update(page_params)
      redirect_to admin_pages_path, notice: "Page updated."
    else
      render :edit
    end
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def authorize_page
    authorize @page
  end

  def page_params
    params.require(:page).permit(:title, :body)
  end
end
