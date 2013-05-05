class CreateRepos < ActiveRecord::Migration
  def change
    create_table :repos do |t|
      t.string :clone_url 
      t.integer :user_id 
      t.string :name
      t.timestamps
    end
  end
end
