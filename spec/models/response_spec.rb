require "rails_helper"

RSpec.describe Response, :type => :model do
  let!(:participant) { Participant.create(first_name: "Maria",
                                          last_name: "Pacana") }
  let!(:mission) {Mission.create({title: "Mission",
                                  description: "Yay",
                                  start_time: DateTime.new(2016,1,1)})}
  let!(:challenge) {mission.challenges.create({location: "SF",
                                               question: "blah",
                                               response_success: "blah",
                                               response_failure: "blah"})}
  describe "#initialize" do
    it { should belong_to(:participant)}
    it { should belong_to(:challenge)}
    it { should validate_presence_of(:text)}
    it { should validate_presence_of(:participant_id)}
    it { should validate_presence_of(:challenge_id)}
    it { should validate_attachment_content_type(:picture).
                  allowing('image/png', 'image/gif').
                  rejecting('text/plain', 'text/xml')}
  end
end
