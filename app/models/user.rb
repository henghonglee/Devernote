class User < ActiveRecord::Base
  require 'open-uri'
  require 'json'
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable,:omniauth_providers => [:evernote,:github]
  attr_accessible :provider, :uid, :everauth , :github_username
  # Setup accessible (or protected) attributes for your model
  serialize :tags
  attr_accessible :email, :password, :password_confirmation, :remember_me, :tags
  # attr_accessible :title, :body
  has_many :repos
  def setGitHubUsername(username)
    self.github_username = username
    self.save
    @repos = JSON.parse(open("https://api.github.com/users/#{username}/repos").read)    

    for repo in @repos
      created_repo =  Repo.create(  
                           clone_url: repo["clone_url"],
                           name: repo["name"]
                           )
      if created_repo.persisted?
        self.repos << created_repo
      end
    end
  end
  
  def self.find_for_evernote_oauth(auth, signed_in_resource=nil)
    puts auth
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(  
                           everauth: auth['credentials']['token'],
                           provider:auth.provider,
                           uid:auth.uid,
                           email: "guest_#{Time.now.to_i}#{rand(99)}@example.com",
                           password:Devise.friendly_token[0,20]
                        )
    end
#    name:auth.extra.raw_info.name,
    puts user.errors.full_messages
    user
  end
  
  
end

