module ApplicationHelper
  def days_since(date)
    (Time.zone.today - date.to_date).to_i
  end

  def layout_mode
    return :plain if current_page?(root_path)
    return :auth if devise_controller?

    :app
  end
end
