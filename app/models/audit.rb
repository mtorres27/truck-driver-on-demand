# frozen_string_literal: true

# == Schema Information
#
# Table name: audits
#
#  id              :bigint           not null, primary key
#  auditable_id    :integer
#  auditable_type  :string
#  associated_id   :integer
#  associated_type :string
#  user_id         :integer
#  user_type       :string
#  username        :string
#  action          :string
#  audited_changes :jsonb
#  version         :integer          default(0)
#  comment         :string
#  remote_address  :string
#  request_uuid    :string
#  created_at      :datetime
#

class Audit < Audited::Audit

  include PgSearch

  pg_search_scope :search, against: {
    auditable_type: "A",
    comment: "B",
    audited_changes: "C",
  }, using: {
    tsearch: { prefix: true },
  }

end
