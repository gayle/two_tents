# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(title)
    content_for :title do
      "#{title} - Northwest Plains District Family Camp"
    end if title
    content_tag(:h2, title)
  end
  def registration_stats
    num_families = Family.registered.size
    num_participants = Participant.registered.size
    "#{num_families} families, #{num_participants} participants"
  end

  def get_messages
    if ! flash[:error].blank?
      create_message_tag(:error)
    elsif ! flash[:notice].blank?
      create_message_tag(:notice)
    elsif ! flash[:success].blank?
      create_message_tag(:success)
    end
  end

  def create_message_tag(type)
    if type == :error
      content_tag(:div, flash[type], { :id => "error_messages", :class => type })
    else
      content_tag(:div, flash[type], { :id => "messages", :class => type })
    end
  end

  def greeting
    "Logged in as #{ current_user.name }!"
  end

  def body_class
    "homepage" if controller.controller_name == 'landing' && controller.action_name == 'index'
  end

  def format_validation_errors (validation_errors=nil) 
    #Errors array is a nested array that looks like this:
    # Element with issues
    # 	Issues for that element.
    #This function turns the error into:
    #	Element #1 with issues errors
    #	Elenent #2 with issues errors
    validation_errors ? validation_errors.to_a.collect{|element| element.join(" ") }.join("\n") : ""
  end

  def format_flash_error(general_message, technical_message=nil, validation_errors=nil)
    message = general_message
    if technical_message or validation_errors
      message << "<br />[TECHNICAL DETAILS:"
      message << "<br /> Tech message: #{technical_message.gsub(/\n/, "\n<br/>")}" if technical_message.present?
      message << "<br /> Validation errors: <br />#{validation_errors.gsub(/\n/, "\n<br />")}" if validation_errors.present?
      message << "]"
    end
    message
  end
end
