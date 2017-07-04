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
