class AgeGroup < ActiveRecord::Base

  SORT_BY_OPTIONS = ["age", "name"]

  def display_min
    min > 99 ? "99" : min.to_s
  end
  def display_max
    max > 99 ? "99" : max.to_s
  end

  def get_participants
    Participant.registered.all(
      :conditions => ["birthdate >= ? AND birthdate <= ?", (max+1).years.ago, min.years.ago],
      :order => (sortby == "age" ? "birthdate DESC, lastname ASC, firstname ASC" :
                                   "lastname ASC, firstname ASC"))
  end
end
