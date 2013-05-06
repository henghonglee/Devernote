class Addhookidtorepo < ActiveRecord::Migration
  def up
    add_column :repos, :hook_id, :integer 
  end

  def down
  end
end
