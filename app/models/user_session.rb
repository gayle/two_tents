class UserSession < Authlogic::Session::Base
  # include ActiveModel::Naming
  # def parents
  #   []
  # end
  #
  # def name
  #   "UserSession"
  # end

  extend ActiveModel::Naming
end
