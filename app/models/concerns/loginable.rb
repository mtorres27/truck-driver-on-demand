module Loginable
  extend ActiveSupport::Concern

  class_methods do
    def find_or_create_from_auth_hash(auth_hash, loginable_id = nil)
      email = auth_hash.dig(:info, :email)&.downcase
      return nil unless email # Dirty hack to not proceed unless we have an email

      identity = Identity.find_or_initialize_by(
        loginable_type: name,
        provider: auth_hash[:provider],
        uid: auth_hash[:uid].to_s
      )

      # Three options:
      # 1) Associate this identity with the existing loginable that was passed in.
      # 2) Associate this identity with an existing loginable that was the same type and email.
      identity.loginable =
        find_by(id: loginable_id) ||
        find_by(email: email)

      # 3) Create a new loginable of the type passed but only if we didn't pass an id to
      # an existing one, and it's not an Admin login (never create admins on the fly).
      unless identity.loginable || loginable_id || name == "Admin"
        identity.loginable = create!(name: auth_hash.dig(:info, :name), email: email)
      end

      if identity.loginable
        identity.last_sign_in_at = Time.zone.now
        identity.save
      end

      identity.loginable
    end
  end

  def last_sign_in_at
    # Delegated to identities
    identities.order(last_sign_in_at: :desc).limit(1).first.last_sign_in_at
  end

  included do
    has_secure_token
  end
end
