require "rails_helper"

RSpec.describe Mission, :type => :model do
  describe "#initialize" do
    it { should have_many(:challenges)}
    it { should validate_presence_of(:title)}
    it { should validate_presence_of(:description)}
    it { should validate_presence_of(:start_time)}

    it "validates that start time is after today" do
      invalid_mission = Mission.new({title: "Awesome Mission",
                                     description: "Weird Time",
                                     start_time: DateTime.new(1966,1,1)})

      expect(invalid_mission).to_not be_valid
    end
  end
end