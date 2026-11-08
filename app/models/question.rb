class Question < ApplicationRecord
  belongs_to :subtopic
  has_one :competency, through: :subtopic
  has_many :options, dependent: :destroy
  accepts_nested_attributes_for :options, allow_destroy: true, 
    reject_if: ->(attrs) { attrs["body"].blank? && attrs["id"].blank? }

  enum :difficulty, { easy: 0, medium: 1, hard: 2 }, default: :medium
  enum :status, { draft:0, pending: 1, approved: 2 }, default: :draft

  validates :body, presence: true
  validate :exactly_one_correct_option

  def exactly_one_correct_option
    errors.add(:base, "Exactly one option must be correct") unless options.reject(&:marked_for_destruction?).count(&:correct) == 1
  end

end
