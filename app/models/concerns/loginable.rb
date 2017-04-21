module Loginable
  extend ActiveSupport::Concern

  class_methods do
    def find_or_create_from_auth_hash(auth_hash:, loginable_id: nil)
      # auth_hash.deep_symbolize_keys!
      email = auth_hash.dig(:info, :email)&.downcase
      return nil unless email # Dirty hack to not proceed unless we have an email

      identity = Identity.find_or_initialize_by(
        loginable_type: name,
        provider: auth_hash[:provider],
        uid: auth_hash[:uid].to_s
      )

      # Three options:
      #   1) Associate this identity with the existing loginable that was passed in.
      #   2) Associate this identity with an existing loginable that was the same type and email.
      #   3) Create a new loginable of the type passed
      identity.loginable =
        find_by(id: loginable_id) ||
        find_by(email: email) ||
        create!(name: auth_hash.dig(:info, :name), email: email)

      identity.save if identity.changed?

      identity.loginable
    end
  end
end
