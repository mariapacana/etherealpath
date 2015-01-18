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
end