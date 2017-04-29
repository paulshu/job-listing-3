class Favorite::JobsController < ApplicationController
  before_action :authenticate_user!

  def index
    @jobs = current_user.favorite_jobs
  end


end
