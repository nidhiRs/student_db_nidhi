class Student < ApplicationRecord
  belongs_to :institution
  default_scope { where(pending: false) }
  scope :pending_students, -> { unscope(where: :pending).where(pending: true) }
  scope :search_by_full_name, -> (full_name) { where("full_name LIKE ?", "%#{full_name}%") }
  scope :search_by_name, -> (name) { where('institutions.name LIKE ?', "%#{name}%") }
end
