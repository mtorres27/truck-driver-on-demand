# frozen_string_literal: true

class UpdateAutoIncrementFromUsers < ActiveRecord::Migration[5.1]
  def up
    execute("ALTER SEQUENCE users_id_seq RESTART WITH 2000")
  end

  def down
    # Do nothing
  end
end
