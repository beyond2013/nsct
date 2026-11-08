class Competency < ApplicationRecord
  has_many :subtopics, dependent: :destroy
  has_many :questions, through: :subtopics

  validates :name, presence: true
  validates :weight, numericality: { in: 1..100 }
end
