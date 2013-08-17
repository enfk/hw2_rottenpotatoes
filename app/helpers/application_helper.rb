module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    path = {:sort => column, :direction => direction}
    if params[:ratings]
      params[:ratings].each_key do |key|
        path['ratings['+key+']'] = '1'
      end
    end
    link_to title, path, {:class => css_class}
  end

  def sortby(column)
    column == sort_column
  end

  def checked(rating)
    params[:ratings] ? params[:ratings].keys.include?(rating) : true
  end
end

