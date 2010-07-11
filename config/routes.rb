ActionController::Routing::Routes.draw do |map|
  map.with_options :path_prefix => 'admin' do |admin|
    admin.resources :participants

    admin.resources :contacts, :only => [:new, :create]

    admin.resources :families
    admin.with_options :controller => 'families' do |family|
      family.edit_choose_family '/edit_choose_family', :action => 'edit_choose_family'
      family.update_add_participant '/update_add_participant', :action => 'update_add_participant'
    end

    admin.with_options :controller => 'reports' do |report|
      report.participants_by_age '/participants_by_age', :action => 'participants_by_age'
      report.families_by_state '/families_by_state', :action => 'families_by_state'
      report.birthdays_by_month '/birthdays_by_month', :action => 'birthdays_by_month'
    end

    admin.with_options :controller => 'config_edit' do |config|
      config.config_edit '/config', :action => 'index', :conditions => {:method => :get}
      config.config_edit '/config', :action => 'update', :conditions => {:method => :post}
    end

    admin.resources :users,
              :collection => { :enter_login => :post },
              :member => { :get_question => :get,
                           :answer_question => :post,
                           :show_password => :get,
                           :change_password => :put }

    admin.dashboard '/dashboard', :controller => 'dashboard', :action => 'index'
  end

  map.with_options :controller => 'sessions' do |session|
    session.logout '/logout', :controller => 'sessions', :action => 'destroy'
    session.login '/login', :controller => 'sessions', :action => 'new'
  end

  map.with_options :controller => 'users' do |user|
    user.register '/register', :action => 'create'
    user.signup '/signup', :action => 'new'
    user.password '/password', :action => 'reset_login'
  end

  map.resource :session

  map.root :controller => 'content', :action => 'landing'
  map.connect ':action', :controller => 'content'
end
