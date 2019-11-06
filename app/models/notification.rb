# frozen_string_literal: true

# == Schema Information
#
# Table name: notifications
#
#  id              :bigint           not null, primary key
#  authorable_type :string           not null
#  authorable_id   :bigint           not null
#  receivable_type :string           not null
#  receivable_id   :bigint           not null
#  body            :text
#  title           :text
#  read_at         :datetime
#  url             :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Notification < ApplicationRecord

  belongs_to :authorable, polymorphic: true
  belongs_to :receivable, polymorphic: true

  validates :body, :title, :authorable, :receivable, :url, presence: true

  scope :to_show, -> { last(20).reverse }
  scope :unread, -> { where(read_at: nil).reverse }

  def mark_as_read
    update_attribute(:read_at, Time.zone.now)
  end

end
