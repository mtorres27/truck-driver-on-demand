# frozen_string_literal: true

class ApplicationPolicy

  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def admin?
    user.admin?
  end

  def freelancer?
    user.freelancer?
  end

  def company_user?
    user.company_user?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  # Allows scoping AR models based on permissions through Pundit
  # See https://github.com/elabs/pundit#scopes
  class Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end

  end

end
