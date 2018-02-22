class JobInvite < ApplicationRecord
  belongs_to :job
  belongs_to :freelancer
end
