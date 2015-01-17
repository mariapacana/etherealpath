require "rails_helper"

RSpec.describe Participant, :type => :model do
  let(:participant) { Participant.create(first_name: "Maria",
                                         last_name: "Pacana") }
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
end
