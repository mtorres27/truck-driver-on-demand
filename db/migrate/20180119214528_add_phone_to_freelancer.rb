class AddPhoneToFreelancer < ActiveRecord::Migration[5.1]
  def change
    unless column_exists?('freelancers', 'phone_number')
      add_column :freelancers, :phone_number, :string
    end
  end
end
