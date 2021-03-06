ActionController::Routing::Routes.draw do |map|
  map.with_options :path_prefix => 'admin' do |admin|
    admin.resources :age_groups, :collection => {:edit_all => :get, :update_all => :post}

    admin.resources :participants
    admin.with_options :controller => 'participants' do |participant|
      participant.new_choose_family 'new_choose_family/:id', :action => 'new_choose_family'
      participant.review '/review', :action => 'review'
      participant.ajax_review_past_participant '/ajax_review_past_participant/:id', :action => 'ajax_review_past_participant'
      participant.unregister_past_participant '/unregister_past_participant/:id', :action => 'unregister_past_participant'
      participant.update_register '/update_register/:id', :action => 'update_register'
    end

    admin.resources :families
    admin.with_options :controller => 'families' do |family|
      family.families_past '/families_past', :action => 'families_past'
      family.edit_choose_family '/edit_add_to_family', :action => 'edit_add_to_family'
      family.update_add_participant '/update_add_participant', :action => 'update_add_participant'
    end

    admin.with_options :controller => 'reports' do |report|
      report.participants_by_age  '/participants_by_age',   :action => 'participants_by_age'
      report.participants_by_age  '/participants_by_grade', :action => 'participants_by_grade'
      report.families_by_state    '/families_by_state',     :action => 'families_by_state'
      report.birthdays_by_month   '/birthdays_by_month',    :action => 'birthdays_by_month'
      report.list_of_cds          '/list_of_cds',           :action => 'list_of_cds'
      report.dietary_restrictions '/dietary_restrictions',  :action => 'dietary_restrictions'
    end

    admin.with_options :controller => 'years' do |year|
      year.edit_years '/years', :action => 'edit', :conditions => {:method => :get}
      year.update_years '/years', :action => 'update', :conditions => {:method => :post}
    end

    admin.resources :users,
              :collection => { :enter_login => :post },
              :member => { :get_question => :get,
                           :answer_question => :post,
                           :show_password => :get,
                           :change_password => :put }

    admin.dashboard '/dashboard', :controller => 'dashboard', :action => 'index'
  end

  map.resources :contacts, :only => [:new, :create]

  map.resource :session
  map.with_options :controller => 'sessions' do |session|
    session.logout '/logout', :controller => 'sessions', :action => 'destroy'
    session.login '/login', :controller => 'sessions', :action => 'new'
  end

  map.with_options :controller => 'users' do |user|
    user.register '/register', :action => 'create'
    user.signup '/signup', :action => 'new'
    user.password '/password', :action => 'reset_login'
  end

  map.root :controller => 'content', :action => 'index'
  map.connect ':action', :controller => 'content'
end
