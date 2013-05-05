class User < ActiveRecord::Base
  require 'open-uri'
  require 'json'
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:omniauthable,:omniauth_providers => [:evernote]
  attr_accessible :provider, :uid, :everauth , :github_username
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
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
#<OmniAuth::AuthHash credentials=#<OmniAuth::AuthHash secret="" token="S=s1:U=658fa:E=145ca42a16f:C=13e72917573:P=185:A=henghonglee-4022:V=2:H=27e49235f48129a42ce807d6fbd65cab"> extra=#<OmniAuth::AuthHash access_token=#<OAuth::AccessToken:0x007fefd789b920 @token="S=s1:U=658fa:E=145ca42a16f:C=13e72917573:P=185:A=henghonglee-4022:V=2:H=27e49235f48129a42ce807d6fbd65cab", @secret="", @consumer=#<OAuth::Consumer:0x007fefd7e050c8 @key="henghonglee-4022", @secret="05d185d673f7f3d7", @options={:signature_method=>"HMAC-SHA1", :request_token_path=>"/oauth", :authorize_path=>"/OAuth.action", :access_token_path=>"/oauth", :proxy=>nil, :scheme=>:header, :http_method=>:post, :oauth_version=>"1.0", :site=>"https://sandbox.evernote.com"}, @http=#<Net::HTTP sandbox.evernote.com:443 open=false>, @http_method=:post>, @params={:oauth_token=>"S=s1:U=658fa:E=145ca42a16f:C=13e72917573:P=185:A=henghonglee-4022:V=2:H=27e49235f48129a42ce807d6fbd65cab", "oauth_token"=>"S=s1:U=658fa:E=145ca42a16f:C=13e72917573:P=185:A=henghonglee-4022:V=2:H=27e49235f48129a42ce807d6fbd65cab", :oauth_token_secret=>"", "oauth_token_secret"=>"", :edam_shard=>"s1", "edam_shard"=>"s1", :edam_userId=>"415994", "edam_userId"=>"415994", :edam_expires=>"1399257735535", "edam_expires"=>"1399257735535", :edam_noteStoreUrl=>"https://sandbox.evernote.com/shard/s1/notestore", "edam_noteStoreUrl"=>"https://sandbox.evernote.com/shard/s1/notestore", :edam_webApiUrlPrefix=>"https://sandbox.evernote.com/shard/s1/", "edam_webApiUrlPrefix"=>"https://sandbox.evernote.com/shard/s1/"}> raw_info=<Evernote::EDAM::Type::User id:415994, username:"henghonglee", privilege:NORMAL (1), active:true, shardId:"s1", accounting:<Evernote::EDAM::Type::Accounting uploadLimit:62914560, uploadLimitEnd:1368428400000, uploadLimitNextMonth:62914560, premiumServiceStatus:NONE (0)>>> info=#<OmniAuth::AuthHash::InfoHash name=nil nickname="henghonglee"> provider="evernote" uid=415994>
