class AgeGroup < ActiveRecord::Base
  SORT_BY_OPTIONS = ["age", "name"]

  # TODO can make this a named scope?
  def participants
    p = Participant.registered.where(birthdate: (max+1).years.ago..min.years.ago) # (max+1).years.ago, min.years.ago)
    p = p.order(birthdate: :desc) if sortby == "age"
    p.order(lastname: :asc, firstname: :asc)
  end
end
