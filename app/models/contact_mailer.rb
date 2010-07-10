class ContactMailer < ActionMailer::Base
  def contact_email(contact)
    recipients CONTACT_EMAIL
    from       "#{contact.name} <#{contact.email}>"
    subject    "[familycamp CONTACT] #{contact.subject}"
    sent_on    Time.now
    body       "#{contact.comment}"
  end
end
