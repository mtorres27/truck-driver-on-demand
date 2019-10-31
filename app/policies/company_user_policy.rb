# frozen_string_literal: true

class CompanyUserPolicy < ApplicationPolicy

  def index?
    true
  end

  def show?
    company_owner? || current_user?
  end

  def edit?
    company_owner? || current_user?
  end

  def update?
    company_owner? || current_user?
  end

  def new?
    company_owner? && available_user_slots?
  end

  def create?
    company_owner? && available_user_slots?
  end

  def destroy?
    company_owner?
  end

  def enable?
    company_owner?
  end

  def disable?
    company_owner?
  end

  private

  def company_owner?
    user.role == "Owner" && record.company == user.company
  end

  def current_user?
    record.id == user.id
  end

  def available_user_slots?
    return false unless user.company_user?

    user.company.available_user_slots?
  end

end
