class RepoController < ApplicationController
  require 'net/http'
  require 'httparty'
  def index
  end
  
  def update_repo
    Resque.enqueue(GitWorker,current_user.id,params[:repo_id])
    redirect_to devernote_index_path
  end
  
  def show #toggle hooks
    repo = Repo.find(params[:id])
    if !repo.hooked
      # go create a hook
      Resque.enqueue(GitWorker,params[:user_id],params[:id])
        response = HTTParty.post("https://api.github.com/repos/#{current_user.github_username}/#{repo.name}/hooks?access_token=#{current_user.github_authtoken}",:body=> 
        {
          :name => "web",
          :active => true,
          :events => [
            "push"
          ],
          :config => {
            :url => "#{root_url}repo_hook?repo_id=#{repo.id}&user_id=#{current_user.id}",
            :content_type => "json"
          }
        }.to_json,
        :headers=> {"User-Agent" => "github.hs/0.7.0"})
        puts response
        repo.hook_id = response["id"]
        repo.hooked = true
        repo.save
    else
      response = HTTParty.delete("https://api.github.com/repos/#{current_user.github_username}/#{repo.name}/hooks/#{repo.hook_id}?access_token=#{current_user.github_authtoken}",:headers=> {"User-Agent" => "github.hs/0.7.0"})
      puts response
      repo.hook_id = nil
      repo.hooked = false
      repo.save
      
    end

    redirect_to devernote_index_path
  end
  
  def edit
  end

  def hook
    Resque.enqueue(GitWorker,params[:user_id],params[:repo_id])
    render :json => {:success=>true}
  end
  def create
    @repo = Repo.new(params[:repo])
    @repo.save
    current_user.repos << @repo
    current_user.save
    redirect_to devernote_index_path
  end

  def new
    @repo = Repo.new
  end

  def destroy
    @repo = Repo.find(params[:id])
    @repo.destroy
  end

  def update
  end
end
