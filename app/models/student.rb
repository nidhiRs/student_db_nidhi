class Student < ApplicationRecord
  belongs_to :institution
  default_scope { where(pending: false) }
  scope :pending_students, -> { unscope(where: :pending).where(pending: true) }
end
