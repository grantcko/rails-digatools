class AddColumnToTool < ActiveRecord::Migration[7.0]
  def change
    add_column :tools, :column, :integer
  end
end
