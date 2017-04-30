class JobsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :edit, :destroy, :favorites, :unfavorite]
  before_action :validate_search_key, only: [:search]
  def index
    @jobs = case params[:order]
    when 'by_lower_bound'
      Job.published.order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 6)
    when 'by_upper_bound'
      Job.published.order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 6)
    else
      Job.published.recent.paginate(:page => params[:page], :per_page => 6)
    end
  end

  def show
    @job = Job.find(params[:id])

    if @job.is_hidden
      flash[:warning] = "This Job alreay archived"
      redirect_to jobs_path
    end
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    
    if @job.save
      redirect_to jobs_path
    else
      render :new
    end
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to admin_jobs_path
    else
      render :edit
    end
  end

  def destroy
    @job = Job.find(params[:id])

    @job.destroy
    redirect_to jobs_path
  end

  def search
    if @query_string.present?
      search_result = Job.published.ransack(@search_criteria).result(:distinct => true)
      @jobs = search_result.paginate(:page => params[:page], :per_page => 5 )
    end
  end

  def favorites
    @job = Job.find(params[:id])
    if !current_user.is_favorite_of?(@job)
      current_user.favorite!(@job)
      flash[:notice] = "收藏成功，可以到我收藏的工作中查看。"
    else
      flash[:warning] = "此工作已收藏！"
    end
      redirect_to :back
  end

  def unfavorite
    @job = Job.find(params[:id])
    if current_user.is_favorite_of?(@job)
      current_user.unfavorite!(@job)
      flash[:notice] = "已取消收藏"
    else
      flash[:warning] = "此工作未被收藏！"
    end
      redirect_to :back
  end

  private

  def validate_search_key
    @query_string = params[:q].gsub(/\\|\'|\/|\?/, "") if params[:q].present?
    @search_criteria = search_criteria(@query_string)
  end


  def search_criteria(query_string)
    { :title_cont => query_string }
  end

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :city, :is_hidden)
  end

end
