module ApplicationHelper
  def controller?(*controller)
    controller.include? params[:controller]
  end
  
  def action?(*action)
    action.include? params[:action]
  end
  
  def options_for_link(resource, opts = {})
    {class: (current_page?(url_for resource) ? 'active' : nil)}.merge(opts)
  end
end
