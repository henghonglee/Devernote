class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  require 'open-uri'
  require 'json'
    def evernote
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_evernote_oauth(request.env["omniauth.auth"], current_user)
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      else

        redirect_to root_path
      end
    end
    def github
      if not request.env['omniauth.auth']['credentials']['token']
      redirect_to root_path
      end  
      current_user.github_username = request.env["omniauth.auth"]["extra"]["raw_info"]["login"]
      current_user.github_authtoken =request.env['omniauth.auth']['credentials']['token']
      current_user.tags = ["TODO","FIXME","XXX"]
      current_user.save
      #list hooks
      # find in config key -> url key
      # https://api.github.com/repos/henghonglee/BehaviorTree/hooks?access_token=15c4d3473b30dbf40bb3fcd51d9dea0264a94c75
      
      @repos = JSON.parse(open("https://api.github.com/users/#{current_user.github_username}/repos").read)    

      for repo in @repos
        
        created_repo =  Repo.create(  
                             html_url: repo["html_url"],
                             clone_url: repo["clone_url"],
                             hooked: false,
                             name: repo["name"]
                             )
        if created_repo.persisted?
          current_user.repos << created_repo
        end
      end
      redirect_to devernote_index_path
    end
 
end