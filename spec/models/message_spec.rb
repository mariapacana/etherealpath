require "rails_helper"

RSpec.describe Message, :type => :model do
  let!(:mission) { Mission.create({title: "Awesome Mission",
                  description: "Yay",
                  intro: "Enigmatic Intro",
                  warning: "Obscure Warning",
                  decline_confirmation: "OK fine",
                  finish_confirmation: "Congrats",
                  location_invite: "rooted, SF, or Ebay?",
                  completed_challenges_required: 3,
                  start_time: DateTime.now+1})}
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
  let!(:participant) { Participant.create(first_name: "Maria",
                                          last_name: "Pacana",
                                          intro_accepted: true,
                                          warning_accepted: true,
                                          declined: false) }
  let!(:participant_unconfirmed) { Participant.create(first_name: "Waffly",
                                                    last_name: "McWaffle",
                                                    code: "5555",
                                                    intro_accepted: false,
                                                    warning_accepted: false,
                                                    declined: false) }

  describe "#initialize" do
    it { should belong_to(:participant)}
    it { should validate_presence_of(:text)}
  end

  describe "#replies_from_ether" do
    before { participant_unconfirmed.mission = mission }
    before { participant.mission = mission }
    context "if participant hasn't confirmed participation" do
      let(:message) {participant_unconfirmed.messages.create({text: "Yes"})}
      it "should call #confirm_interest" do
        expect(participant_unconfirmed).to receive(:confirm_interest).with("Yes")
        message.replies_from_ether
      end
    end
    context "if participant has confirmed participation" do
      context "if participant just selected a challenge location" do
        it "should respond with a challenge question" do
          message = participant.messages.create({text: "SF"})
          expect(message.replies_from_ether).to include(challenge1.question)
          expect(participant.current_challenge).to eq(challenge1)
        end
      end
      context "if participant just responded to a challenge" do
        it "should call #check_response" do
          participant.assign_to_challenge(challenge1)
          expect(participant).to receive(:check_response).with("Yay", [])
          message = participant.messages.create({text: "Yay"})
          message.replies_from_ether
        end
      end
    end
  end
end