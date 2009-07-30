ActionController::Routing::Routes.draw do |map|
  map.resources :participants, :collection => {:new_from_user => :get, :create_from_user => :post}
  map.resources :families
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.family_registration '/family_registration', :controller => 'families', :action => 'family_registration'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.staff '/staff', :controller => 'staff', :action => 'index'
  map.resources :users, :member => { :reset_password => :put }
  map.resources :files

  map.with_options :controller => 'forgotten_password' do |p|
    p.password '/password', :action => 'index'
    p.retrieve_question '/password/retrieve_question', :action => 'retrieve_question'
    p.retrieve_question '/password/answer_question', :action => 'answer_question'
  end
  map.password '/password', :controller => 'forgotten_password', :action => 'index'
  map.resource :session
  map.landing '/', :controller => 'landing', :action => 'index'
  map.config_edit '/config', :controller => 'config_edit', :action => 'index', :conditions => {:method => :get}
  map.config_edit '/config', :controller => 'config_edit', :action => 'update', :conditions => {:method => :post}
  map.rooms '/rooms', :controller => 'rooms', :action => 'index', :conditions => {:method => :get}
  map.rooms '/rooms', :controller => 'rooms', :action => 'update', :conditions => {:method => :post}

  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
