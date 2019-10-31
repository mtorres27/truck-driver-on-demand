# frozen_string_literal: true

class AuditPolicy < ApplicationPolicy

  def index?
    admin?
  end

end
