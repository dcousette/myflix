module ApplicationHelper
  def star_count_options
    (1..5).map{|num| ["#{ pluralize(num, 'Star') }", num] }
  end

  def options_for_video_reviews(selected=nil)
    options_for_select(star_count_options, selected)
  end

  def options_for_categories
    options_for_select(Category.all.map { |cat| [cat.name, cat.id] })
  end
end
