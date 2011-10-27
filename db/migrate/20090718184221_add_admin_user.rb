class AddAdminUser < ActiveRecord::Migration
  def self.up
    execute %{INSERT INTO participants (lastname, firstname) values ('administrator','administrator')}
    results = execute %{SELECT id FROM participants ORDER BY id DESC}
    most_recent_participant_id = results.first

    # NOTE: Previous insert into participants was changed from previous version where it was using Participant.new.
    # This should not use the modal here, either.  But User doesn't actually have a "password" or "password_confirmation"
    # field, only a crypted_password field.  Don't want to reinvent the wheel here for how that encryption takes place.
    # Using model for now until can think of a better way.  Or when I'm not working on this at 2am. Something like that.
    u = User.new(:login => "administrator",
                 :password => "administrator",
                 :password_confirmation => "administrator",
                 :email => "administrator@example.com")
    u.participant_id = most_recent_participant_id
    u.save_without_validation!
  end

  def self.down
    execute %{DELETE FROM users WHERE login = 'administrator'}
    execute %{DELETE FROM participants WHERE lastname = 'administrator'}
  end
end
