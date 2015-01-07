require "rails_helper"

RSpec.describe Participant, :type => :model do
  let(:participant) { Participant.create(first_name: "Maria",
                                         last_name: "Pacana") }
  describe "#initialize" do
    it { should belong_to(:challenge)}
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}

    it "should set up a dummy code" do
      expect(participant.code).to eq("aaaa")
    end
  end
end
