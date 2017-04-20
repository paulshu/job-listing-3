module JobsHelper

  def render_job_status(job)
    if job.is_hidden
      content_tag(:span, "", :class => "fa fa-lock fa-lg") #fa-lg是设置图标尺寸的参数
    else
      content_tag(:span, "", :class => "fa fa-globe fa-lg")
    end
  end
end
