class AddDefaultToTags4 < ActiveRecord::Migration
  def change
    change_column :users, :tags, :text  
  end
end
