# == Schema Information
#
# Table name: friend_invites
#
#  id            :integer          not null, primary key
#  email         :citext           not null
#  name          :string           not null
#  freelancer_id :integer          not null
#  accepted      :boolean          default(FALSE)
#

class FriendInvite < ApplicationRecord
  belongs_to :freelancer

  validates :name, :email, :freelancer_id, presence: true
  validate :number_of_invites_below_six
  validate :hasnt_been_invited_by_freelancer

  after_create :send_invite_email

  scope :accepted, -> { where(accepted: true) }
  scope :pending, -> { where(accepted: false) }
  scope :by_email, ->(email) { where(email: email) }
  scope :by_freelancer, ->(freelancer) { where(freelancer_id: freelancer.id) }

  private

  def number_of_invites_below_six
    return if FriendInvite.by_email(email).count < 5
    errors.add(:base, "#{email} has already been invited by others to join AVJunction.")
  end

  def hasnt_been_invited_by_freelancer
    return if FriendInvite.by_email(email).by_freelancer(freelancer).count.zero?
    errors.add(:base, "You already invited #{email}.You cannot invite the same person more than once.")
  end

  def send_invite_email
    FriendInvitesMailer.send_invite(email, name, freelancer).deliver_later
  end
end