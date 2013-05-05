class Repo < ActiveRecord::Base
  belongs_to :user
   attr_accessible :clone_url, :name
   validates_uniqueness_of :clone_url
end
