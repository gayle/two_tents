ActionController::Routing::Routes.draw do |map|
  map.with_options :path_prefix => 'admin' do |admin|
    admin.resources :participants, :collection => {:new_from_user => :get, :create_from_user => :post}
    admin.resources :families
    admin.resources :contacts, :only => [:new, :create]
    admin.dashboard '/dashboard', :controller => 'staff', :action => 'index'
    admin.edit_choose_family '/edit_choose_family', :controller => 'families', :action => 'edit_choose_family'
    admin.update_add_participant '/update_add_participant', :controller => 'families', :action => 'update_add_participant'

    admin.participants_by_age '/participants_by_age', :controller => 'reports', :action => 'participants_by_age'
    admin.families_by_state '/families_by_state', :controller => 'reports', :action => 'families_by_state'
    admin.birthdays_by_month '/birthdays_by_month', :controller => 'reports', :action => 'birthdays_by_month'

    admin.config_edit '/config', :controller => 'config_edit', :action => 'index', :conditions => {:method => :get}
    admin.config_edit '/config', :controller => 'config_edit', :action => 'update', :conditions => {:method => :post}
    admin.resources :users,
              :collection => { :enter_login => :post },
              :member => { :get_question => :get,
                           :answer_question => :post,
                           :show_password => :get,
                           :change_password => :put }
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

  map.resources :files
  map.resource :session

  map.root :controller => 'content', :action => 'landing'
  map.connect ':action', :controller => 'content'
end
