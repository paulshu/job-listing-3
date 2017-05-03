class Admin::JobsController < ApplicationController
  before_action :authenticate_user!, only:[:new, :create, :update, :destroy, :edit]
  before_action :find_job_and_check_permission, only: [:edit, :update, :destroy]
  before_action :require_is_admin
  layout "admin"

  def show
    @job = Job.find(params[:id])
  end

  def index

    #@jobs = current_user.jobs.paginate(:page => params[:page], :per_page => 6)
    #可以这样写也可以用where(:user => current_user)代替current_user.jobs
    #@jobs = Job.all.paginate(:page => params[:page], :per_page => 6)
    #则会显示所有用户的工作，即不会区别不同的企业用户来显示
    #以上两种均不会实现分页功能！

    @jobs = case params[:order]
    when 'by_lower_bound'
      Job.where(:user => current_user).order('wage_lower_bound DESC').paginate(:page => params[:page], :per_page => 6)
    when 'by_upper_bound'
      Job.where(:user => current_user).order('wage_upper_bound DESC').paginate(:page => params[:page], :per_page => 6)
    else
      current_user.jobs.recent.paginate(:page => params[:page], :per_page => 6)
    end  #以上采用了不同方法来确认当前用户,两个表达方法都是没有问题的。
  end

  def new
    @job = Job.new
  end

  def create
    @job = Job.new(job_params)
    @job.user = current_user
    if @job.save
      redirect_to admin_jobs_path
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
      flash[:notice] = "更新成功"
    else
      render :edit
    end
  end

  def destroy
    @job =Job.find(params[:id])

    @job.destroy

    redirect_to admin_jobs_path, alert:"已删除该招聘信息"
  end

  def publish
    @job =Job.find(params[:id])
    @job.publish!
    redirect_to :back
  end

  def hide
    @job =Job.find(params[:id])
    @job.hide!
    redirect_to :back #返回当前位置
  end

  private

  def find_job_and_check_permission
    @job = Job.find(params[:id])
    if @job.user != current_user
      redirect_to admin_jobs_path, alert:"你没有权限进行此操作。"
    end
  end

  def job_params
    params.require(:job).permit(:title, :description, :wage_lower_bound, :wage_upper_bound, :contact_email, :city, :is_hidden)
  end


end
