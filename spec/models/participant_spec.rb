require "rails_helper"

RSpec.describe Participant, :type => :model do
  let!(:mission) { Mission.create({title: "Awesome Mission",
                  description: "Yay",
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
                                         last_name: "Pacana") }
  let!(:participant_with_phone) { Participant.create(first_name: "Phony",
                                                    last_name: "McPhone") }
  let!(:participant_with_code) { Participant.create(first_name: "Cody",
                                                    last_name: "McCode",
                                                    code: "6666")}

  describe "#initialize" do
    it { should have_many(:phone_numbers)}
    it { should have_many(:responses)}
    it { should have_many(:challenges).through(:responses) }
    it { should belong_to(:current_challenge).with_foreign_key(:current_challenge_id) }
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}

    it "should set up a dummy code" do
      expect(participant.code).to eq("aaaa")
    end
  end

  describe ".find_by_name_or_code" do
    let(:number) {"+16666666666"}
    context "with a participant that has a phone" do
      it "should return the correct participant given the number" do
        participant_with_phone.phone_numbers.create(number: number)
        expect(Participant.find_by_name_or_code(phone: number, code: "")).to eq(participant_with_phone)
      end
    end
    context "with a participant that has a code" do
      it "should return the correct participant given the code" do
        participant = Participant.find_by_name_or_code(phone: number, code: "6666")
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

  describe "when figuring out what challenge to assign" do
    before(:each) do
      participant.mission = mission
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
        response = Response.create(text: "hey2")
        response.participant = participant
        response.challenge = challenge2
        response.mark_correct

        next_challenge = participant.next_challenge("East Bay")
        expect(next_challenge).to eq(challenge3)
      end
    end

    describe "#assign_to_next_challenge" do
      it "assigns participant to the next challenge" do
        participant.assign_to_next_challenge("East Bay")
        expect([challenge2, challenge3]).to include(participant.current_challenge)
      end
    end
  end

  # When deciding the next message to send

    # 1: participant just responded to a challenge
      # a. participant is correct
        # i. they finished the game
          # - congratulate them
        # ii. they're not finished
          # - give them response_success
          # - set current_challenge to nil
          # - ask them what type of challenge they want next
      # b. participant is wrong
        # - give them response_failure
      # c. LATER: it's a picture challenge
        # - tell them we're checking on it
    # 2. participant is saying what challenge they want
      # assign them to a challenge of the type they want
      # send them the challenge question

  describe "#next_messages" do
    context "if participant isn't assigned to a challenge" do
      it "should respond with a challenge question" do
        participant.mission = mission
        next_messages = participant.next_messages(response_text: "SF")
        expect(participant.current_challenge).to eq(challenge1)
        expect(next_messages).to include(challenge1.question)
      end
    end
    context "if a participant is solving a challenge, but it isn't the last" do
      before(:each) do
        participant.mission = mission
        response = Response.create(text: "hey")
        response.participant = participant
        response.challenge = challenge2
        response.mark_correct
        challenge1.answers.create({text: "hooray"})
        participant.assign_to_next_challenge(challenge1.location)
      end

      it "should give them a success response and ask where they want the next challenge to be located" do
        next_messages = participant.next_messages(response_text: "hooray")
        expect(next_messages).to include(challenge1.response_success)
        expect(next_messages).to include("Where would you like to go next (SF, East Bay, home?)")
        expect(participant.current_challenge).to be nil
      end
      it "should tell them they're wrong otherwise" do
        expect(participant.next_messages(response_text: "whoa so wrong")).to include(challenge1.response_failure || "Sorry, wrong answer!")
      end
    end
    context "if participant is on their last challenge" do
      before(:each) do
        participant.mission = mission
        [challenge1, challenge2].each do |challenge|
          response = Response.create(text: "hey")
          response.participant = participant
          response.challenge = challenge
          response.mark_correct
        end
        challenge3.answers.create({text: "incandescent"})
        participant.assign_to_next_challenge(challenge3.location)
      end

      it "should congratulate them when they get it right" do
        expect(participant.next_messages(response_text: "incandescent")).to include("Congratulations, you finished!")
      end
      it "should tell them they're wrong otherwise" do
        expect(participant.next_messages(response_text: "whoa so wrong")).to include(challenge3.response_failure || "Sorry, wrong answer!")
      end
    end
  end
end
