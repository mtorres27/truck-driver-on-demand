class FriendInvite < ApplicationRecord
  belongs_to :freelancer

  validate :number_of_invites_below_six
  validate :hasnt_been_invited_by_freelancer

  after_create :send_invite_email

  scope :accepted, -> { where(accepted: true) }
  scope :pending, -> { where(accepted: false) }

  private

  def number_of_invites_below_six
    if FriendInvite.where(email: email).count >= 5
      errors.add(:base, "#{email} has already been invited 5 times to join AVJunction.")
    end
  end

  def hasnt_been_invited_by_freelancer
    if FriendInvite.where(freelancer: freelancer).count > 0
      errors.add(:base, "You cannot invite the same person more than once.")
    end
  end

  def send_invite_email
    FriendInvitesMailer.send_invite(email, name, freelancer).deliver
  end
end
