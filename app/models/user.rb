class User < ActiveRecord::Base
  acts_as_authentic do |c|
    # c.my_config_option = my_value # for available options see documentation in: Authlogic::ActsAsAuthentic
    c.validate_email_field = false
    c.act_like_restful_authentication = true
  end # block optional
end
