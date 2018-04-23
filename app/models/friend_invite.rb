# == Schema Information
#
# Table name: friend_invites
#
#  id            :integer          not null, primary key
#  email         :citext
#  name          :string
#  freelancer_id :integer
#  accepted      :boolean          default(FALSE)
#

class FriendInvite < ApplicationRecord
  belongs_to :freelancer

  validates :name, :email, presence: true
  validate :number_of_invites_below_six
  validate :hasnt_been_invited_by_freelancer

  after_create :send_invite_email

  scope :accepted, -> { where(accepted: true) }
  scope :pending, -> { where(accepted: false) }

  private

  def number_of_invites_below_six
    if FriendInvite.where(email: email).count >= 5
      errors.add(:base, "#{email} has already been invited by others to join AVJunction.")
    end
  end

  def hasnt_been_invited_by_freelancer
    if FriendInvite.where(email: email, freelancer: freelancer).count > 0
      errors.add(:base, "You already invited #{email}.You cannot invite the same person more than once.")
    end
  end

  def send_invite_email
    FriendInvitesMailer.send_invite(email, name, freelancer).deliver
  end
end
