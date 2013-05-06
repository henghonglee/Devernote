class AddDefaultToTags2 < ActiveRecord::Migration
  def change
    change_column :users, :tags, :text , :default => ["TODO","FIXME","XXX"]
  end
end
