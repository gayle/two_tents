# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def registration_stats
    num_families = Family.find(:all).size
    num_participants = Participant.find(:all).size
    "#{num_families} families, #{num_participants} participants."
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
    content_tag(:div, flash[type], { :id => "messages", :class => type })
  end

  def greeting
    "Logged in as #{ current_user.name }!"
  end

  def body_class
    "homepage" if controller.controller_name == 'landing' && controller.action_name == 'index'
  end
end
