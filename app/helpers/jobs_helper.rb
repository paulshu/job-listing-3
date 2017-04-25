module JobsHelper

  def render_job_status(job)
    if job.is_hidden
      content_tag(:span, "", :class => "fa fa-lock fa-lg") #fa-lg是设置图标尺寸的参数
    else
      content_tag(:span, "", :class => "fa fa-globe fa-lg")
    end
  end

  def render_highlight_content(job,query_string)
    excerpt_cont = excerpt(job.title, query_string, radius: 500)
    highlight(excerpt_cont, query_string)
  end
  
end
