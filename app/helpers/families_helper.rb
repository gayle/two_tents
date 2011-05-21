module FamiliesHelper

  def move_main_contact_to_front(participants)
    participants = participants.sort_by{|a| a.main_contact.to_s}
    main_family_contact=participants.pop
    participants.unshift(main_family_contact)
    participants
  end

  def attributes_blank?(attributes)
    # check a few that should never be blank
    return (attributes[:firstname].blank? and
            attributes[:lastname].blank? and
            attributes[:birthdate].blank?)

    # maybe expand this to check for each attribute, is it blank or 0?
  end

  def link_to_add_participant_fields(name, f, link_options = {})  
    new_object = Participant.new  
    fields = f.fields_for(:participants, new_object, :child_index => "new_participants") do |builder|  
      render(:partial => 'participant_fields', :locals => { :pfields => builder })
    end  
    link_to_function(name, h("add_fields(this, \"participants\", \"#{escape_javascript(fields)}\")"), link_options)  
  end


end
