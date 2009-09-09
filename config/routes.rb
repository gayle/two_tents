ActionController::Routing::Routes.draw do |map|
  map.resources :participants, :collection => {:new_from_user => :get, :create_from_user => :post}
  map.resources :families
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.family_registration '/family_registration', :controller => 'families', :action => 'family_registration'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.staff '/staff', :controller => 'staff', :action => 'index'
  map.resources :users,
                :collection => { :enter_login => :post },
                :member => { :get_question => :get, :answer_question => :post, :show_password => :get, :change_password => :put }
  map.password '/password', :controller => 'users', :action => 'reset_login'
  map.resources :files
  map.resource :session
  map.config_edit '/config', :controller => 'config_edit', :action => 'index', :conditions => {:method => :get}
  map.config_edit '/config', :controller => 'config_edit', :action => 'update', :conditions => {:method => :post}
  map.rooms '/rooms', :controller => 'rooms', :action => 'index', :conditions => {:method => :get}
  map.rooms '/rooms', :controller => 'rooms', :action => 'update', :conditions => {:method => :post}

  map.connect ':action', :controller => 'content'
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
