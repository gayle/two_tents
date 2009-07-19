# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_messages
    if flash[:error]
      create_message_tag(:error)
    elsif flash[:notice]
      create_message_tag(:notice)
    elsif flash[:success]
      create_message_tag(:success)
    end
  end
  
  def create_message_tag(type)
    content_tag(:div, flash[type], { :id => "messages", :class => type })
  end
  
  def greeting
    "Logged in as #{ current_user.name }!"
  end
end
