class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :attempt
  belongs_to :option, optional: true
  
end
