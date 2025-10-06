module ApplicationHelper
  def active_class(path)
    return [ "active", true ] if current_page?(path)

    [ "", nil ]
  end
end
