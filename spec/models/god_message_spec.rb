require "rails_helper"

RSpec.describe GodMessage, :type => :model do
  let!(:mission) {Mission.create({title: "Awesome Mission",
                                 description: "Weird Time",
                                 intro: "You have a choice",
                                 current: true,
                                 warning: "Be very afraid",
                                 decline_confirmation: "OK fine",
                                 finish_confirmation: "Congrats",
                                 location_invite: "rooted, SF, or Ebay?",
                                 completed_challenges_required: 3,
                                 start_time: DateTime.new(2020,1,1)})}
  describe "#initialize" do
    it { should belong_to(:mission)}
    it { should validate_presence_of(:text)}
    it { should validate_presence_of(:mission_id)}

    it "only accepts 'SF' or 'East Bay' as locations" do
      valid_gm = mission.god_messages.create({text: "I am the Lord",
                                               location: "SF"})
      invalid_gm = mission.god_messages.create({text: "I am the Lord",
                                               location: "Mars"})
      expect(valid_gm).to be_valid
      expect(invalid_gm).not_to be_valid
    end
  end
end