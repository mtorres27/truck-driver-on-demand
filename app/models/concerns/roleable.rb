module Roleable
  extend ActiveSupport::Concern

  COMPANY_ROLES = [
    :admin,
    :owner,
    :manager,
  ].freeze

  def add_valid_role(role)
    if COMPANY_ROLES.include?(role)
      update(role: role)
    else
      errors.add(:roles, :invalid)
    end
  end

  def company_admin?
    role.to_sym == :admin
  end

  def company_owner?
    role.to_sym == :owner
  end

  def company_manager?
    role.to_sym == :manager
  end
end
