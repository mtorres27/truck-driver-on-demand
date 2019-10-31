# frozen_string_literal: true

class AdminPolicy < ApplicationPolicy

  def index?
    admin?
  end

  def download_csv?
    admin?
  end

end
