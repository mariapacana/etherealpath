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
                                               question: "How now#brown cow",
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

  describe "#is_a_cry_for_help" do
    let(:plea) {participant.messages.create({text: "angel"})}
    it "should return true if the text includes angel" do
      expect(plea.is_a_cry_for_help).to be true
    end
  end

  describe "#replies_from_ether" do
    before { participant.mission = mission }
    before { participant_unconfirmed.mission = mission }
    context "if participant is asking for help" do
      it "should flag the participant as needing help" do
        message = participant.messages.create({text: "angel", incoming: true})
        expect(message.replies_from_ether).to include("What's the trouble, sweet thing? Be patient, and a voice may respond shortly.")
        expect(participant.needs_help).to be true
      end
    end
    context "if participant hasn't confirmed participation" do
      let (:message) {participant_unconfirmed.messages.create({text: "Yes"})}
      it "should send the participant the mission's warning" do
        # expect(participant_unconfirmed).to receive(:confirm_interest).with("Yes")  # TODO: Investigate why this is broken
        expect(message.replies_from_ether).to include("Obscure Warning")
      end
    end
    context "if participant has confirmed participation" do
      context "if participant just selected a challenge location" do
        context "if the question is the size of one text" do
          it "should respond with a single-text challenge question" do
            message = participant.messages.create({text: "SF"})
            expect(message.replies_from_ether).to include(challenge1.question)
            expect(participant.current_challenge).to eq(challenge1)
          end
        end
        context "if the question is the size of two texts" do
          it "should respond with a two-text question" do
            message = participant.messages.create({text: "East Bay"})
            replies = message.replies_from_ether
            expect(replies).to include("How now")
            expect(replies).to include("brown cow")
            expect(participant.current_challenge).to eq(challenge2)
          end
        end
      end
      context "if the question is the size of two texts" do
        it "should respond with a two-text question" do
          message = participant.messages.create({text: "East Bay"})
          replies = message.replies_from_ether
          expect(replies).to include("How now")
          expect(replies).to include("brown cow")
          expect(participant.current_challenge).to eq(challenge2)
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