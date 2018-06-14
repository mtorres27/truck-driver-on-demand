# == Schema Information
#
# Table name: audits
#
#  id              :integer          not null, primary key
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
# Indexes
#
#  associated_index              (associated_id,associated_type)
#  auditable_index               (auditable_id,auditable_type)
#  index_audits_on_created_at    (created_at)
#  index_audits_on_request_uuid  (request_uuid)
#  user_index                    (user_id,user_type)
#

class Audit < Audited::Audit
  include PgSearch

  pg_search_scope :search, against: {
    auditable_type: "A",
    comment: "B",
    audited_changes: "C"
  }, using: {
    tsearch: { prefix: true }
  }

end
