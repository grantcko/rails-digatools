class ChangeLinksAndInternalCategoriesFromTools < ActiveRecord::Migration[7.0]
  def change
    remove_column :tools, :internal_categories
    add_column :tools, :internals, :string, default: [], array: true
    remove_column :tools, :links
    add_column :tools, :links, :string, default: [], array: true
  end
end
