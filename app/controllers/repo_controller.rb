class RepoController < ApplicationController
  require 'net/http'
  def index
    
      
  end
  
  def show #toggle hooks
    repo = Repo.find(params[:id])
    if !repo.hooked
      # go create a hook
      # POST https://api.github.com/repos/henghonglee/BehaviorTree/hooks?access_token=15c4d3473b30dbf40bb3fcd51d9dea0264a94c75
      uri = URI.parse("https://api.github.com/repos/#{current_user.github_username}/#{repo.name}/hooks?access_token=#{current_user.github_authtoken}")
      response = Net::HTTP.post_form(uri, {
        "name"=> "web",
        "active"=> true,
        "events"=> [
          "push"
        ],
        "config"=> {
          "url"=> "#{root_url}repo?repo_id=#{repo.id}&user_id=#{current_user.id}",
          "content_type"=> "json"
        }
        })
        puts response
        #repo.hooked = true
        #repo.save
    else
      # @repohooks =  JSON.parse(open("https://api.github.com/repos/#{current_user.github_username}/#{repo.name}/hooks?access_token=#{current_user.github_authtoken}").read)
      # for repohook in @repohooks
      #   if repohook["config"]["url"] == "#{root_url}repo?repo_id=#{repo.id}&user_id=#{current_user.id}"
      #     puts "found existing hooks"
      #   end
      # end
    end
#    Resque.enqueue(GitWorker,params[:user_id],params[:id])
    redirect_to root_path
  end
  
  def edit
    
  end

  def create
    # TODO: render something useful here
    Resque.enqueue(GitWorker,params[:user_id],params[:repo_id])
    render :text => "sent worker to queue"
  end

  def new
  end

  def destroy
  end

  def update
  end
end
