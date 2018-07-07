class AdminPolicy < ApplicationPolicy

  def index?
    admin?
  end

  def download_csv?
    admin?
  end

end