require "rails_helper"

RSpec.describe Challenge, :type => :model do
  describe "#initialize" do
    it { should belong_to(:mission)}
    it { should have_many(:responses)}
    it { should have_many(:participants).through(:responses) }
    it { should have_many(:current_participants).with_foreign_key(:current_challenge_id) }
    it { should have_many(:answers)}

    it { should validate_presence_of(:location)}
    it { should validate_presence_of(:question)}
    it { should validate_presence_of(:response_success)}
    it { should validate_presence_of(:response_failure)}

    it "only accepts 'SF', 'East Bay', or 'rooted' as locations" do
      valid_challenge = Challenge.create({location: "SF",
                                         question: "blah",
                                         response_success: "blah",
                                         response_failure: "blah"})
      invalid_challenge = Challenge.create({location: "Mars",
                                           question: "blah",
                                           response_success: "blah",
                                           response_failure: "blah"})
      expect(valid_challenge).to be_valid
      expect(invalid_challenge).not_to be_valid
    end
  end

  describe "#next and #previous"
    let!(:mission) {Mission.create({title: "Mission",
                                   description: "Yay",
                                   start_time: DateTime.new(2016,1,1)})}
    let!(:challenge1) {mission.challenges.create({location: "SF",
                                                   question: "blah",
                                                   response_success: "blah",
                                                   response_failure: "blah"})}
    let!(:challenge2) {mission.challenges.create({location: "East Bay",
                                                 question: "blah",
                                                 response_success: "blah",
                                                 response_failure: "blah"})}
    describe "#next" do
      it "gets you the next challenge in a mission" do
        expect(challenge1.next()).to eq(challenge2)
      end
    end
    describe "#previous" do
      it "gets you the previous challenge in a mission" do
        expect(challenge2.prev()).to eq(challenge1)
      end
    end
end