class Tool < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :internals, presence: true

  internals = ['custom', 'color_picker', 'auto_equalizer', 'prompt_generator']

  validates :internals, inclusion: { in: internals, message: "is not a valid item" }, allow_nil: true
  validate :internal_array?

  def internal_array?
    unless internals.is_a?(Array)
      errors.add(:my_column, "must be an array")
      return false
    end
    true
  end
end
