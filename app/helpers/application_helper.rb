module ApplicationHelper
  def star_count_options
    (1..5).map{|num| ["#{ pluralize(num, 'Star') }", num] }
  end
end
