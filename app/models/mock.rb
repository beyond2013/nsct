class Mock < ApplicationRecord
  has_many :attempts, dependent: :destroy

  validates :title, presence: true
  validates :duration_minutes, :total_questions, 
             numericality: { only_integer: true, greater_than: 0 }

  scope :active, -> { where(active: true) }

end
