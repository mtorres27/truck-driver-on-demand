module Disableable
  extend ActiveSupport::Concern

  def disable!
    self.disabled = true
    save(validate: false)
  end

  def enable!
    self.disabled = false
    save(validate: false)
  end

  included do
    scope :enabled, -> { where(disabled: false) }
    scope :disabled, -> { where(disabled: true) }
  end
end
