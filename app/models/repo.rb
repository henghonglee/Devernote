class Repo < ActiveRecord::Base
  belongs_to :user
   attr_accessible :clone_url, :name,:html_url, :hooked,:hook_id
   validates_uniqueness_of :clone_url
end
