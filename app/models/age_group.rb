class AgeGroup < ActiveRecord::Base

  SORT_BY_OPTIONS = ["age", "name"]

  def display_min
    min > 99 ? "99" : min.to_s
  end
  def display_max
    max > 99 ? "99" : max.to_s
  end

  def get_participants()
    # This was easier to select and sort at the same time when .registered was a named scope on Participant.
    participants = Participant.registered.select { |p|
      p.birthdate >= (max+1).years.ago and p.birthdate <=  min.years.ago
    }
    if sortby == "age"
      participants.sort! {|p1, p2|
        (p2.birthdate <=> p1.birthdate).nonzero? || (p1.lastname <=> p2.lastname).nonzero? || (p1.firstname <=> p2.firstname)
      }
    elsif sortby == "name"
      participants.sort! {|p1, p2|
        (p1.lastname <=> p2.lastname).nonzero? || (p1.firstname <=> p2.firstname)
      }
    end
    return participants
  end
end
