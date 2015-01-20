require "rails_helper"

RSpec.describe Participant, :type => :model do
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
  let!(:participant_with_phone) { Participant.create(first_name: "Phony",
                                                    last_name: "McPhone",
                                                    intro_accepted: true,
                                                    warning_accepted: true,
                                                    declined: false) }
  let!(:participant_with_code) { Participant.create(first_name: "Cody",
                                                    last_name: "McCode",
                                                    code: "6666",
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
    it { should have_many(:phone_numbers)}
    it { should have_many(:messages)}
    it { should have_many(:responses)}
    it { should have_many(:challenges).through(:responses) }
    it { should belong_to(:current_challenge).with_foreign_key(:current_challenge_id) }
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}
  end

  describe ".find_by_phone_or_code" do
    let(:number) {"+16666666666"}
    context "with a participant that has a phone" do
      it "should return the correct participant given the number" do
        participant_with_phone.phone_numbers.create(number: number)
        expect(Participant.find_by_phone_or_code(phone_number: number, code: "")).to eq(participant_with_phone)
      end
    end
    context "with a participant that has a code" do
      it "should return the correct participant given the code" do
        participant = Participant.find_by_phone_or_code(phone_number: number, code: "6666")
        expect(participant).to eq(participant_with_code)
        expect(PhoneNumber.find_by(number: number).participant).to eq(participant_with_code)
      end
    end
  end

  describe "#assign_to_challenge" do
    it "assigns participant to a challenge" do
      participant.assign_to_challenge(challenge1)
      expect(participant.current_challenge).to eq(challenge1)
      expect(participant.current_challenge_id).to eq(challenge1.id)
    end
  end

  describe "#assign_to_mission" do
    it "assigns participant to a mission" do
      participant.assign_to_mission(mission)
      expect(participant.mission).to eq(mission)
    end
  end

  describe "#not_on_a_mission?" do
    context "when a participant doesn't have a mission" do
      it "should be false" do
        expect(participant.not_on_a_mission?).to be true
      end
    end
    context "after a participant is assigned to a mission" do
      it "should be true" do
        participant.mission = mission
        expect(participant.not_on_a_mission?).to be false
      end
    end
  end

  describe "#unassigned_to_a_challenge" do
    before(:each) do
      participant.mission = mission
    end
    it "returns true when a participant isn't on a challenge yet" do
      expect(participant.unassigned_to_a_challenge).to be true
    end
    it "returns false when the participant has a current challenge" do
      participant.assign_to_challenge(challenge1)
      expect(participant.unassigned_to_a_challenge).to be false
    end
  end

  describe "#unassign_from_challenge" do
    it "should set the current challenge to nil" do
      participant.mission = mission
      participant.assign_to_challenge(challenge1)

      participant.unassign_from_challenge()

      expect(participant.current_challenge).to be nil
    end
  end

  describe "when confirming interest" do
    before(:each) do
      participant_unconfirmed.assign_to_mission(mission)
    end

    describe "#participation_unconfirmed" do
      it "should be true when if the warning or intro are unaccepted" do
        expect(participant_unconfirmed.participation_unconfirmed).to be true
        participant_unconfirmed.intro_accepted = true
        expect(participant_unconfirmed.participation_unconfirmed).to be true
      end
    end

    describe "#has_accepted_neither_intro_nor_warning" do
      it "should be true when both warning and intro are unaccepted" do
        expect(participant_unconfirmed.has_accepted_neither_intro_nor_warning).to be true
        participant_unconfirmed.intro_accepted = true
        expect(participant_unconfirmed.has_accepted_neither_intro_nor_warning).to be false
      end
    end

    describe "#has_accepted_only_intro" do
      it "should be true when only the intro was accepted" do
        expect(participant_unconfirmed.has_accepted_only_intro).to be false
        participant_unconfirmed.intro_accepted = true
        expect(participant_unconfirmed.has_accepted_only_intro).to be true
      end
    end

    describe "#confirm_interest" do
      context "when the participant accepts the intro" do
        it "should return the warning for the mission" do
          expect(participant_unconfirmed.confirm_interest("Yes")).to eq(mission.warning)
          expect(participant_unconfirmed.intro_accepted).to be true
          expect(participant_unconfirmed.declined).to be false
        end
      end
      context "when the participant rejects the intro" do
        it "should return the decline confirmation for the mission" do
          expect(participant_unconfirmed.confirm_interest("No")).to eq(mission.decline_confirmation)
          expect(participant_unconfirmed.intro_accepted).to be false
          expect(participant_unconfirmed.declined).to be true
        end
      end
      context "when the participant accepts the warning" do
        it "should set the warning_accepted flag to true" do
          participant_unconfirmed.intro_accepted = true
          expect(participant_unconfirmed.confirm_interest("Yeah")).to eq(mission.location_invite)
          expect(participant_unconfirmed.warning_accepted).to be true
        end
      end
      context "when the participant rejects the warning" do
        it "should set declined to true and warning_accepted to false" do
          participant_unconfirmed.intro_accepted = true
          expect(participant_unconfirmed.confirm_interest("No")).to eq(mission.decline_confirmation)
          expect(participant_unconfirmed.warning_accepted).to be false
          expect(participant_unconfirmed.declined).to be true
        end
      end
    end
  end

  describe "when assigning challenges" do
    before(:each) do
      participant.mission = mission
      message = participant.messages.new(text: "hey")
      response = Response.new(text: "hey")
      response.participant = participant
      response.challenge = challenge1
      response.mark_correct
    end

    describe "#completed_challenges" do
      it "returns a list of challenges the participant completed" do
        expect(participant.completed_challenges).to include(challenge1)
      end
    end

    describe "#uncompleted_challenges" do
      it "returns a list of challenges the participant hasn't finished" do
        expect(participant.uncompleted_challenges).to include(challenge3)
        expect(participant.uncompleted_challenges).not_to include(challenge1)
      end
    end

    describe "#next_challenge" do
      it "can give another challenge of a new type" do
        next_challenge = participant.next_challenge("East Bay")
        expect([challenge2, challenge3]).to include(next_challenge)
      end
      it "can give another challenge of the same type" do
        Response.create_with_associations(text: "hey2",
                                          participant: participant,
                                          challenge: challenge2).mark_correct
        next_challenge = participant.next_challenge("East Bay")
        expect(next_challenge).to eq(challenge3)
      end
      it "isn't fussy about the way the location is spelled" do
        next_challenge = participant.next_challenge("  east bay   ")
        expect([challenge2, challenge3]).to include(next_challenge)
      end
    end

    describe "#assign_to_next_challenge" do
      it "assigns participant to the next challenge" do
        participant.assign_to_next_challenge("East Bay")
        expect([challenge2, challenge3]).to include(participant.current_challenge)
      end
    end
  end

  describe "#assign_to_last_challenge" do
    it "should assign a participant to the last challenge" do
      participant.mission = mission
      Response.create_with_associations(response_text: "hey", challenge: challenge1, participant: participant).mark_correct
      Response.create_with_associations(response_text: "hey", challenge: challenge2, participant: participant).mark_correct

      participant.assign_to_last_challenge
      expect(participant.current_challenge).to eq(challenge3)
    end
  end

  describe "when checking responses" do
    describe "#finished_mission?" do
      it "should return true if the participant's done all the challenges" do
        participant.mission = mission
        mission.challenges.each do |challenge|
          Response.create_with_associations(response_text: "hey", challenge: challenge, participant: participant).mark_correct
        end
        expect(participant.finished_mission?).to be true
      end
    end
    describe "#should_be_sent_to_last_challenge?" do
      it "should return true if the participant's done almost all the challenges" do
        participant.mission = mission
        Response.create_with_associations(response_text: "hey", challenge: challenge1, participant: participant).mark_correct
        Response.create_with_associations(response_text: "hey", challenge: challenge2, participant: participant).mark_correct

        expect(participant.should_be_sent_to_last_challenge?).to eq(true)
      end
    end
    describe "#finished_the_last_challenge?" do
      it "should return true if the participant's done all the challenges" do
        participant.mission = mission
        Response.create_with_associations(response_text: "hey", challenge: challenge3, participant: participant).mark_correct

        expect(participant.finished_the_last_challenge?).to be true
      end
    end

    describe "#check_response" do
      before(:each) do
        participant.mission = mission
      end
      let! (:messages) { [] }
      context "if their answer is correct" do
        context "if participant has done all but the last challenge" do
          it "should assign them to the last challenge" do
            Response.create_with_associations(response_text: "hey", challenge: challenge1, participant: participant).mark_correct
            participant.assign_to_challenge(challenge2)
            challenge2.answers.create({text: 'whoop'})

            participant.check_response("whoop", messages)
            expect(messages).to include(challenge2.response_success)
            expect(messages).to include(challenge3.question)
            expect(participant.current_challenge).to eq(challenge3)
          end
        end
        context "if their last answer completes the mission" do
          it "should congratulate them on ending the mission" do
            [challenge1, challenge2].each do |challenge|
              Response.create_with_associations(response_text: "hey", challenge: challenge, participant: participant).mark_correct
            end
            challenge3.answers.create({text: "yay"})
            participant.assign_to_last_challenge

            participant.check_response("yay", messages)
            expect(messages).to include(mission.finish_confirmation)
          end
        end
        context "if they are nowhere near the end" do
          it "should just ask them the next location" do
            participant.assign_to_challenge(challenge1)
            challenge1.answers.create({text: "ok"})

            participant.check_response("  ok ", messages)
            expect(messages).to include(challenge1.response_success)
            expect(messages).to include(participant.mission.location_invite)
          end
        end
      end
    end
  end
end