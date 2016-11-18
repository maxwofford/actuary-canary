# PagesHelper holds helper methods that are accessible on all views
module PagesHelper
  def full_title(page_title)
    base_title = 'Actuary Canary'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
