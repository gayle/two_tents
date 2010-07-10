ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'content', :action => 'landing'
  map.resources :participants, :collection => {:new_from_user => :get, :create_from_user => :post}
  map.resources :families
  map.resources :contacts
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.family_registration '/family_registration', :controller => 'families', :action => 'family_registration'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.staff '/staff', :controller => 'staff', :action => 'index'
  map.edit_choose_family '/edit_choose_family', :controller => 'families', :action => 'edit_choose_family'
  map.update_add_participant '/update_add_participant', :controller => 'families', :action => 'update_add_participant'
  map.participants_by_age '/participants_by_age', :controller => 'reports', :action => 'participants_by_age'
  map.families_by_state '/families_by_state', :controller => 'reports', :action => 'families_by_state'
  map.birthdays_by_month '/birthdays_by_month', :controller => 'reports', :action => 'birthdays_by_month'
  map.resources :users,
                :collection => { :enter_login => :post },
                :member => { :get_question => :get, :answer_question => :post, :show_password => :get, :change_password => :put }
  map.password '/password', :controller => 'users', :action => 'reset_login'
  map.resources :files
  map.resource :session
  map.config_edit '/config', :controller => 'config_edit', :action => 'index', :conditions => {:method => :get}
  map.config_edit '/config', :controller => 'config_edit', :action => 'update', :conditions => {:method => :post}

  map.connect ':action', :controller => 'content'
end
