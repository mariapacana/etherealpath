require "rails_helper"

RSpec.describe Mission, :type => :model do
  describe "#initialize" do
    it { should have_many(:challenges)}
    it { should validate_presence_of(:title)}
    it { should validate_presence_of(:description)}
    it { should validate_presence_of(:intro)}
    it { should validate_presence_of(:warning)}
    it { should validate_presence_of(:decline_confirmation)}
    it { should validate_presence_of(:finish_confirmation)}
    it { should validate_presence_of(:location_invite)}
    it { should validate_presence_of(:start_time)}
    it { should validate_presence_of(:completed_challenges_required)}

    it "validates that start time is after today" do
      invalid_mission = Mission.new({title: "Awesome Mission",
                                     description: "Weird Time",
                                     intro: "You have a choice",
                                     warning: "Be very afraid",
                                     decline_confirmation: "OK fine",
                                     finish_confirmation: "Congrats",
                                     location_invite: "rooted, SF, or Ebay?",
                                     completed_challenges_required: 3,
                                     start_time: DateTime.new(1966,1,1)})

      expect(invalid_mission).to_not be_valid
    end
  end

  describe "#last_challenge" do
    let!(:mission) {Mission.create({title: "Awesome Mission",
                                   description: "Weird Time",
                                   intro: "You have a choice",
                                   warning: "Be very afraid",
                                   decline_confirmation: "OK fine",
                                   finish_confirmation: "Congrats",
                                   location_invite: "rooted, SF, or Ebay?",
                                   completed_challenges_required: 3,
                                   start_time: DateTime.new(2020,1,1)})}
    let!(:challenge1) {mission.challenges.create({location: "SF",
                                                question: "blah",
                                                response_success: "blah",
                                                response_failure: "blah",
                                                any_answer_acceptable: false})}
    let!(:challenge2) {mission.challenges.create({location: "East Bay",
                                           question: "blah",
                                           response_success: "blah",
                                           response_failure: "blah",
                                           any_answer_acceptable: false})}
    let!(:challenge3) {mission.challenges.create({location: "East Bay",
                                             question: "What's the sun?",
                                             response_success: "blah",
                                             response_failure: "blah",
                                             any_answer_acceptable: false})}
    it "should return the last challenge created for the mission" do
      expect(mission.last_challenge).to eq(challenge3)
    end
  end
end