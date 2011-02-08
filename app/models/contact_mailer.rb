class ContactMailer < ActionMailer::Base
  def contact_email(contact)
    recipients CONTACT_EMAIL
    from       "#{contact.name} <#{contact.email}>"
    subject    "[A message from the family camp website!] #{contact.subject}"
    sent_on    Time.now
    body       "#{contact.comment}"
  end
end
