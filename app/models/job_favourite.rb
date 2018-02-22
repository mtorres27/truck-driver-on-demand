class JobFavourite < ApplicationRecord
  belongs_to :freelancer
  belongs_to :job
end
