class Tool < ApplicationRecord
  belongs_to :user

  INTERNAL_CATEGORIES = ["category_placeholder"]
  enum internal_categories: INTERNAL_CATEGORIES

  validates :name, presence: true
end
