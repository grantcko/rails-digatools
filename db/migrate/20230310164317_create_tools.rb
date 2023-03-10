class CreateTools < ActiveRecord::Migration[7.0]
  def change
    create_table :tools do |t|
      t.string :name
      t.string :note
      t.integer :links, default: [], array: true
      t.string :internal_types, default: [], array: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
