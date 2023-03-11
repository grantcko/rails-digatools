class ChangeInternalTypesFromTools < ActiveRecord::Migration[7.0]
  def change
    remove_column :tools, :internal_types
    add_column :tools, :internal_types, :integer
  end
end
