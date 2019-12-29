# frozen_string_literal: true

class DriverTestResultPolicy < ApplicationPolicy

  def show?
    test_result_owner?
  end

  private

  def test_result_owner?
    return false unless driver?

    record.driver == user
  end

end
