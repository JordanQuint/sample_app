module ApplicationHelper
  #return a title on a per-page basis.
  def title
    base_title = "Mr. Quint's Sample App"
    if !@title.nil?
       "#{base_title} | #{@title}"
    end
  end
end
