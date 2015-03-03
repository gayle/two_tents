module ContentHelper

  def admin_access_link
    # if current_user
    #   link_to "Dashboard", dashboard_url, :class => "admin_access_link"
    # else
    #   link_to "Staff Login", login_url, :class => "login_link admin_access_link"
    # end
    link_to "Staff Login", new_user_session_path, :class => "login_link admin_access_link"
  end

end
