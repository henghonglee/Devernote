class Addtagstousers < ActiveRecord::Migration
  def up
    add_column :users, :tags, :text    
  end

  def down
  end
end
