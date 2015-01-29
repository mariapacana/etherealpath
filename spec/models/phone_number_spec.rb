require "rails_helper"

RSpec.describe PhoneNumber, :type => :model do
  describe "#initialize" do
    it { should belong_to(:participant)}
    it { should validate_presence_of(:number)}
    it { should validate_uniqueness_of(:number)}
  end
end
