class Subtopic < ApplicationRecord
  belongs_to :competency
  has_many :questions, dependent: :destroy
end
