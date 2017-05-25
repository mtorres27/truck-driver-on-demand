class CreateJobs < ActiveRecord::Migration[5.1]
  def change
    create_table :jobs do |t|
      t.references :project, foreign_key: true
      t.string :title, null: false
      t.string :state, null: false, default: "created"
      t.text :summary, null: false
      t.text :scope_of_work
      t.decimal :budget, precision: 10, scale: 2, null: false
      t.string :job_function, null: false
      t.date :starts_on, null: false
      t.date :ends_on
      t.integer :duration, null: false
      t.string :pay_type
      t.string :freelancer_type, null: false
      t.text :keywords
      t.boolean :invite_only, null: false, default: false
      t.boolean :scope_is_public, null: false, default: true
      t.boolean :budget_is_public, null: false, default: true
      t.text :working_days, array: true, null: false, default: []
      t.string :working_time
      t.decimal :contract_price, precision: 10, scale: 2
      t.jsonb :payment_schedule, null: false, default: '{}'
      t.string :reporting_frequency
      t.boolean :require_photos_on_updates, null: false, default: false
      t.boolean :require_checkin, null: false, default: false
      t.boolean :require_uniform, null: false, default: false
      t.text :addendums

      t.integer :applicants_count, null: false, default: 0
      t.integer :messages_count, null: false, default: 0

      t.timestamps
    end
  end
end
