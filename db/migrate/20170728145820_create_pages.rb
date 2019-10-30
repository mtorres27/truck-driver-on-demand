# frozen_string_literal: true

class CreatePages < ActiveRecord::Migration[5.1]
  def change
    create_table :pages do |t|
      t.string :slug, null: false, index: true
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps
    end

    Page.create(
      slug: "privacy-policy",
      title: "AV Junction Privacy Policy",
      body: "This should be markdown and / or html.",
    )

    Page.create(
      slug: "terms-of-service",
      title: "AV Juction Terms of Service",
      body: "This should be markdown and / or html.",
    )
  end
end
