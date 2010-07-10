class Contact < ActiveRecord::Base
  validates_presence_of :name, :email, :subject, :comment
  validates_format_of :email, :with => Authentication.email_regex
end
