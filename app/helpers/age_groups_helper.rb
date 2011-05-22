module AgeGroupsHelper

  def link_to_add_age_group(name, f, link_options = {})  
    new_object = AgeGroup.new
    fields = f.fields_for(:age_groups, new_object) do |group|
      render(:partial => 'fields', :locals => { :group => group })
    end  
    link_to_function(name, h("add_fields(this, \"age_groups\",
                                         \"#{escape_javascript(fields)}\")"),
                     link_options)
  end

end
