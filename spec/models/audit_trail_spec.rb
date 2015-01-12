require 'rails_helper'

RSpec.describe AuditTrail, :type => :model do
  context ".audit" do
    it "should create one with a link" do
      FactoryGirl.create(:audit_trail, link: "http://something.com")
      expect(AuditTrail.first.message).to eq "this is an audit message"
      expect(AuditTrail.first.link).to eq "http://something.com"
    end

    it "should create one without a link" do
      FactoryGirl.create(:audit_trail, link: nil)
      expect(AuditTrail.first.message).to eq "this is an audit message"
      expect(AuditTrail.first.link).to be_nil
    end
  end
end
