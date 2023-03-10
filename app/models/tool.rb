class Tool < ApplicationRecord
  belongs_to :user

  INTERNAL_TYPES = ["Day off", "Paid dayoff", "Time off"]
  enum internal_types: INTERNAL_TYPES

  validates :name, presence: true
end
