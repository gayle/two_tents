module ContentHelper
  def self.rowstyle(row)
    row.even? ? "even" : "odd"
  end

  def admin_access_link
    if current_user
      link_to "Dashboard", dashboard_url, :class => "admin_access_link"
    else
      link_to "Staff Login", login_url, :class => "login_link admin_access_link"
    end
  end

  def whats_new_link
    link_to "What's New for #{Year.current.year}", url_for(:controller => :content, :action => :whats_new), :class => ""
  end
end
