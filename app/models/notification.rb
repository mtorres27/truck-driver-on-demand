# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  authorable_type :string
#  authorable_id   :integer          not null
#  receivable_type :string
#  receivable_id   :integer          not null
#  body            :text
#  title           :text
#  read_at         :datetime
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_notifications_on_authorable_type_and_authorable_id  (authorable_type,authorable_id)
#  index_notifications_on_receivable_type_and_receivable_id  (receivable_type,receivable_id)
#

class Notification < ApplicationRecord
  belongs_to :authorable, polymorphic: true
  belongs_to :receivable, polymorphic: true

  validates :body, :title, :authorable, :receivable, :url, presence: true

  scope :to_show, -> { last(20).reverse }
  scope :unread, -> { where(read_at: nil).reverse }

  def mark_as_read
    self.update_attribute(:read_at, Time.zone.now)
  end
end
