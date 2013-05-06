class AddDefaultToTags3 < ActiveRecord::Migration
  def change
    remove_column :users, :tags, :text
    add_column :users, :tags, :text , :default => ["TODO","FIXME","XXX"]
  end
end
