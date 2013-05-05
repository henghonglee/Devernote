class AddEverAuthColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :everauth, :string
  end
end
