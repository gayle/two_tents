class AgeGroup < ActiveRecord::Base

  SORT_BY_OPTIONS = ["age", "name"]

  def display_min
    min > 99 ? "99" : min.to_s
  end
  def display_max
    max > 99 ? "99" : max.to_s
  end
end
