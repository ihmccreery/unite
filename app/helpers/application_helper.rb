module ApplicationHelper

  def flash_class(level)
    case level
    when :notice then "alert alert-info"
    when :success then "alert alert-success"
    when :error then "alert alert-error"
    when :alert then "alert alert-error"
    end
  end

  def markdown_to_html(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(:filter_html => true))
    Redcarpet::Render::SmartyPants.render(markdown.render(text)).html_safe
  end

end
