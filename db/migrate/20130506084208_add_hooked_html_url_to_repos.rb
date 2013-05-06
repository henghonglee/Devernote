class AddHookedHtmlUrlToRepos < ActiveRecord::Migration
  def change
    add_column :repos, :hooked, :boolean , :default => false
    add_column :repos, :html_url, :string 
  end
end
