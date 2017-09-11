class CompanyFavourite < ApplicationRecord
  belongs_to :freelancer
  belongs_to :company
end
