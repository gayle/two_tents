require File.dirname(__FILE__) + '/../test_helper'

class AgeGroupTest < ActiveSupport::TestCase
  def setup
    @start_of_camp = Year.current.starts_on

    @zero_to_five = Factory(:age_group, :min=>0, :max=>5)
    @six_to_eleven = Factory(:age_group, :min=>6, :max=>11)
    @twelve_to_seventeen = Factory(:age_group, :min=>12, :max=>17)
    @eighteen_and_up = Factory(:age_group, :min=>18, :max=>999)
    assert_equal 4, AgeGroup.all.size
  end

  def test_get_participants
    zero_year_old = Participant.new(:lastname => "Jones", :firstname => "Zero", :birthdate => @start_of_camp-18.days)
    zero_year_old.save!
    five_year_old = Participant.new(:lastname => "Jones", :firstname => "Five", :birthdate => @start_of_camp-5.years)
    five_year_old.save!
    six_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => @start_of_camp-6.years)
    six_year_old.save!
    eleven_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => @start_of_camp-11.years)
    eleven_year_old.save!
    twelve_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => @start_of_camp-12.years)
    twelve_year_old.save!
    seventeen_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => @start_of_camp-17.years)
    seventeen_year_old.save!
    eighteen_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => @start_of_camp-18.years)
    eighteen_year_old.save!
    sixty_year_old = Participant.new(:lastname => "Two", :firstname => "C", :birthdate => @start_of_camp-60.years)
    sixty_year_old.save!


    AgeGroup.all.each do |age_group|
      assert_not_nil age_group.get_participants, "age_group=#{age_group.inspect}"
      assert age_group.get_participants.size > 0, "age group #{age_group.inspect} \nshould have more than 0 participants"
    end

    assert @zero_to_five.get_participants.include? zero_year_old
    assert @zero_to_five.get_participants.include? five_year_old
    assert @six_to_eleven.get_participants.include? six_year_old
    assert @six_to_eleven.get_participants.include? eleven_year_old
    assert @twelve_to_seventeen.get_participants.include? twelve_year_old
    assert @twelve_to_seventeen.get_participants.include? seventeen_year_old
    assert @eighteen_and_up.get_participants.include? eighteen_year_old
    assert @eighteen_and_up.get_participants.include? sixty_year_old
  end

  def test_get_participant_sorting
    six_year_old_CW = Participant.new(:lastname => "Why", :firstname => "C", :birthdate => @start_of_camp-6.years)
    six_year_old_CW.save!
    seven_year_old_AZ = Participant.new(:lastname => "Zee", :firstname => "A", :birthdate => @start_of_camp-7.years)
    seven_year_old_AZ.save!
    seven_year_old_BW = Participant.new(:lastname => "Why", :firstname => "B", :birthdate => @start_of_camp-7.years)
    seven_year_old_BW .save!
    seven_year_old_BZ = Participant.new(:lastname => "Zee", :firstname => "B", :birthdate => @start_of_camp-7.years)
    seven_year_old_BZ .save!

    assert_equal "age", @six_to_eleven.sortby
    participants = @six_to_eleven.get_participants
    assert participants[0] == six_year_old_CW, "List not sorted right: \n#{participants.collect{|p|p.inspect}.join("\n---\n")}"
    assert participants[1] == seven_year_old_BW, "List not sorted right: \n#{participants.collect{|p|p.inspect}.join("\n---\n")}"
    assert participants[2] == seven_year_old_AZ, "List not sorted right: \n#{participants.collect{|p|p.inspect}.join("\n---\n")}"
    assert participants[3] == seven_year_old_BZ, "List not sorted right: \n#{participants.collect{|p|p.inspect}.join("\n---\n")}"

    @six_to_eleven.sortby="name"
    @six_to_eleven.save!
    participants = @six_to_eleven.get_participants
    assert participants[0] == seven_year_old_BW, "List not sorted right: \n#{participants.collect{|p|p.inspect}.join("\n---\n")}"
    assert participants[1] == six_year_old_CW, "List not sorted right: \n#{participants.collect{|p|p.inspect}.join("\n---\n")}"
    assert participants[2] == seven_year_old_AZ, "List not sorted right: \n#{participants.collect{|p|p.inspect}.join("\n---\n")}"
    assert participants[3] == seven_year_old_BZ, "List not sorted right: \n#{participants.collect{|p|p.inspect}.join("\n---\n")}"
  end
end
