class Favourite < ApplicationRecord
  belongs_to :freelancer
  belongs_to :company
end
