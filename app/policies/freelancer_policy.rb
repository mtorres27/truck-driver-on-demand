class FreelancerPolicy < ApplicationPolicy

  def index?
    freelancer?
  end

  def identity?
    freelancer? && freelancer_owner?
  end

  def connect?
    freelancer? && freelancer_owner?
  end

  def prepare_info?
    freelancer? && freelancer_owner?
  end

  def stripe_upload?
    freelancer? && freelancer_owner?
  end

  def bank_account?
    freelancer? && freelancer_owner?
  end

  def add_bank_account?
    freelancer? && freelancer_owner?
  end

  def show?
    freelancer? || company_user? || admin?
  end

  def company_index?
    company_user?
  end

  def hired?
    company_user?
  end

  def favourites?
    (freelancer? && freelancer_owner?) || company_user?
  end

  def edit?
    (freelancer? && freelancer_owner?) || admin?
  end

  def update?
    (freelancer? && freelancer_owner?) || admin?
  end

  def destroy?
    admin?
  end

  def enable?
    admin?
  end

  def disable?
    admin?
  end

  def av_companies?
    freelancer? && freelancer_owner?
  end

  def add_favourites?
    freelancer? && freelancer_owner?
  end

  def my_jobs?
    freelancer? && freelancer_owner?
  end

  def my_applications?
    freelancer? && freelancer_owner?
  end

  def job_matches?
    freelancer? && freelancer_owner?
  end

  def stripe?
    freelancer? && freelancer_owner?
  end

  private

  def freelancer_owner?
    return false unless freelancer?
    record.id == user.id
  end

end
