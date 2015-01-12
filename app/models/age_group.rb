class AgeGroup < ActiveRecord::Base
  SORT_BY_OPTIONS = ["age", "name"]

  # TODO can make this a named scope?
  def participants
    Participant.registered.where(birthdate: (max+1).years.ago..min.years.ago) # (max+1).years.ago, min.years.ago)

    #TODO will need to add sorting depending on value of sortby
    #    :order => (sortby == "age" ? "birthdate DESC, lastname ASC, firstname ASC" :
    #        "lastname ASC, firstname ASC"))
  end
end
