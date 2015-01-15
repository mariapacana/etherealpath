require "rails_helper"

RSpec.describe Answer, :type => :model do
  describe "#initialize" do
    it { should belong_to(:challenge)}
    it { should validate_presence_of(:text)}
  end
end