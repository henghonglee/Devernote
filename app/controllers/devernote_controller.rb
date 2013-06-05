class DevernoteController < ApplicationController
  
  def index
    @newRepo = Repo.new
  end
  
  def refresh
    puts "refreshing repos"
    current_user.github_username = params[:username]
    @repos = JSON.parse(open("https://api.github.com/users/#{current_user.github_username}/repos").read)    
    
    for repo in @repos
      puts repo
      created_repo =  Repo.create(  
                           html_url: repo["html_url"],
                           clone_url: repo["clone_url"],
                           hooked: false,
                           name: repo["name"]
                           )
      
      if created_repo.persisted?
        puts "repo persisted"
        current_user.repos << created_repo
        current_user.save
      end
    end
    redirect_to devernote_index_path
  end
end
