# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(title)
    content_for :title do
      "#{title} - Northwest Plains District Family Camp"
    end if title
    content_tag(:h2, title)
  end
  def registration_stats
    num_families = Family.find(:all).size
    participants = Participant.find_active
    num_participants = participants.size
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
end
