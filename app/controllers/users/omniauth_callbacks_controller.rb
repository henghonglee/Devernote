class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  
    def evernote
      # You need to implement the method below in your model (e.g. app/models/user.rb)
      @user = User.find_for_evernote_oauth(request.env["omniauth.auth"], current_user)
      puts @user.persisted?
      puts @user
      if @user.persisted?
        sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
  #      set_flash_message(:notice, :success, :kind => "facebook") if is_navigational_format?
      else
        puts "new user reg"
        session["devise.evernote_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
    def github
      puts request.env["omniauth.auth"]
      current_user.github_username = request.env["omniauth.auth"]["extra"]["raw_info"]["login"]
      current_user.save
      redirect_to root_path
    end
 
end