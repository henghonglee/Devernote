class Addgithubauthtousers < ActiveRecord::Migration
  def up
    add_column :users, :github_authtoken, :string    
  end

  def down
  end
end
