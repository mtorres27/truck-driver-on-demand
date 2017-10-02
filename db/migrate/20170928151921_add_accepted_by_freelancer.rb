class AddAcceptedByFreelancer < ActiveRecord::Migration[5.1]
  def change
    add_column :quotes, 'accepted_by_freelancer', :boolean, default: false
  end
end
