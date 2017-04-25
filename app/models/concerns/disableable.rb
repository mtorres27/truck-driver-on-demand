module Disableable
  extend ActiveSupport::Concern

  def disable!
    self.disabled = true
    save
  end

  def enable!
    self.disabled = false
    save
  end

  included do
    scope :enabled, -> { where(disabled: false) }
    scope :disabled, -> { where(disabled: true) }
  end
end
