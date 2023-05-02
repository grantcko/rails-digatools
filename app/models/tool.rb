class Tool < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :internals, presence: true
  validates :internals, inclusion: { in: ['custom', 'color_picker'], message: "is not a valid item" }, allow_nil: true
  validate :internal_array?

  private

  def internal_array?
    unless internals.is_a?(Array)
      errors.add(:my_column, "must be an array")
      return false
    end
    true
  end
end
