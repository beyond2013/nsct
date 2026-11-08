class Mock < ApplicationRecord
  has_many :attempts, dependent: :destroy
end
