class Attempt < ApplicationRecord
  belongs_to :user
  belongs_to :mock
  has_many :answers, dependent: :destroy
end
