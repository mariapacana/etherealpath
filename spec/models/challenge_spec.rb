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
      valid_challenge = Challenge.create({location: "East Bay",
                                          question: "blah",
                                          response_success: "blah",
                                          response_failure: "blah",
                                          any_answer_acceptable: false})
      invalid_challenge = Challenge.create({location: "Mars",
                                           question: "blah",
                                           response_success: "blah",
                                           response_failure: "blah",
                                           any_answer_acceptable: false})
      expect(valid_challenge).to be_valid
      expect(invalid_challenge).not_to be_valid
    end
  end

  describe ".current" do
    let!(:mission1) { Mission.create({title: "Awesome Mission",
                    description: "Yay",
                    intro: "Enigmatic Intro",
                    current: true,
                    warning: "Obscure Warning",
                    decline_confirmation: "OK fine",
                    finish_confirmation: "Congrats",
                    location_invite: "rooted, SF, or Ebay?",
                    completed_challenges_required: 3,
                    start_time: DateTime.now+1})}
    let!(:mission2) { Mission.create({title: "Awesome Mission",
                    description: "Yay",
                    intro: "Enigmatic Intro",
                    current: false,
                    warning: "Obscure Warning",
                    decline_confirmation: "OK fine",
                    finish_confirmation: "Congrats",
                    location_invite: "rooted, SF, or Ebay?",
                    completed_challenges_required: 3,
                    start_time: DateTime.now+1})}
    it "should only return challenges with a current mission" do
      challenge1 = mission1.challenges.create({location: "SF",
                                              question: "blah",
                                              response_success: "blah",
                                              response_failure: "blah",
                                              any_answer_acceptable: false})
      challenge2 = mission2.challenges.create({location: "SF",
                                                question: "blah",
                                                response_success: "blah",
                                                response_failure: "blah",
                                                any_answer_acceptable: false})
      expect(Challenge.current).to include(challenge1)
      expect(Challenge.current).not_to include(challenge2)
    end
  end
end