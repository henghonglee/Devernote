class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  require 'open-uri'
  require 'json'
    def evernote
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_evernote_oauth(request.env["omniauth.auth"], current_user)
      puts @user.persisted?
      puts @user
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated

      else
        puts "new user reg"
        session["devise.evernote_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
    def github
      current_user.github_username = request.env["omniauth.auth"]["extra"]["raw_info"]["login"]
      current_user.github_authtoken =request.env['omniauth.auth']['credentials']['token']
      current_user.save
      
      @repos = JSON.parse(open("https://api.github.com/users/#{current_user.github_username}/repos").read)    

      for repo in @repos
        created_repo =  Repo.create(  
                             clone_url: repo["clone_url"],
                             name: repo["name"]
                             )
        if created_repo.persisted?
          current_user.repos << created_repo
        end
      end
      redirect_to root_path
    end
 
end