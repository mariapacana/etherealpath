require "rails_helper"

RSpec.describe Response, :type => :model do
  let!(:participant) { Participant.create(first_name: "Maria",
                                          last_name: "Pacana",
                                          intro_accepted: false,
                                          warning_accepted: false,
                                          declined: false) }
  let!(:mission) {Mission.create({title: "Mission",
                                  description: "Yay",
                                  intro: "Random Intro",
                                  warning: "Obscure Warning",
                                  decline_confirmation: "OK fine",
                                  location_invite: "rooted, SF, or Ebay?",
                                  completed_challenges_required: 3,
                                  start_time: DateTime.new(2016,1,1)})}
  let!(:challenge) {mission.challenges.create({location: "SF",
                                               question: "blah",
                                               response_success: "blah",
                                               response_failure: "blah",
                                               any_answer_acceptable: false})}
  let!(:response) {Response.create(text: "blah")}
  describe "#initialize" do
    it { should belong_to(:participant)}
    it { should belong_to(:challenge)}
    it { should validate_presence_of(:participant_id)}
    it { should validate_presence_of(:challenge_id)}
    it { should validate_attachment_content_type(:picture).
                  allowing('image/png', 'image/gif').
                  rejecting('text/plain', 'text/xml')}
  end

  describe "#create_with_associations" do
    it "creates a response with a challenge and a participant" do
      response =  Response.create_with_associations(text: "hey",
                                                    challenge: challenge,
                                                    participant: participant)
      expect(response.challenge).to eq(challenge)
      expect(response.participant).to eq(participant)
    end
  end

  describe "#mark_correct" do
    it "marks a challenge as correct" do
      response.mark_correct
      expect(response.correct).to be true
    end
  end

  describe "#is_correct?" do
    before(:each) do
      challenge.answers.create({text: "first"})
      challenge.answers.create({text: "second"})
    end
    it "is true when the response text matches an answer exactly" do
      response = Response.create(text: "first")
      response.challenge = challenge
      response.participant = participant

      expect(response.is_correct?).to be true
    end
    it "is true when the response text has the answer with different capitalization" do
      response = Response.create(text: "First")
      response.challenge = challenge
      response.participant = participant

      expect(response.is_correct?).to be true
    end
    it "is true when the response text contains an answer" do
      response = Response.create(text: "  first  ")
      response.challenge = challenge
      response.participant = participant

      expect(response.is_correct?).to be true
    end
    it "is false when the response text does not have the answer" do
      response = Response.create(text: "hell NO")
      response.challenge = challenge
      response.participant = participant

      expect(response.is_correct?).to be false
    end
    it "is true when any answer is acceptable" do
      challenge.any_answer_acceptable = true
      response = Response.create(text: "whatever dude")
      response.challenge = challenge
      response.participant = participant

      expect(response.is_correct?).to be true
    end
  end
end
