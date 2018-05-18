# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  meta_id                :integer
#  meta_type              :string
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  belongs_to :meta, polymorphic: true, optional: true

  after_save :add_credit_to_inviters

  private

  def add_credit_to_inviters
    return if meta_type != 'Freelancer' || !confirmed_at_changed? || FriendInvite.by_email(email).count.zero?
    FriendInvite.by_email(email).each do |invite|
      freelancer = invite.freelancer
      if freelancer.avj_credit.nil?
        credit_earned = 20
      elsif freelancer.avj_credit + 20 <= 200
        credit_earned = 20
      else
        credit_earned = 200 - freelancer.avj_credit
      end
      freelancer.avj_credit = freelancer.avj_credit.to_f + credit_earned
      freelancer.save!
      invite.update_attribute(:accepted, true)
      FreelancerMailer.notice_credit_earned(freelancer, credit_earned).deliver_later if credit_earned > 0
    end
  end
end
