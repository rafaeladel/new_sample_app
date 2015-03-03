module ApplicationHelper
  def full_title(title = '')
    default_title = 'Ruby on Rails Tutorial Sample App'
    if title.empty?
      default_title
    else
      "#{title} | #{default_title}"
    end
  end
end
