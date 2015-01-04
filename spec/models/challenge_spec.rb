require "rails_helper"

RSpec.describe Challenge, :type => :model do
  describe "#initialize" do
    it { should belong_to(:mission)}
    it { should validate_presence_of(:question)}
    it { should validate_presence_of(:answer)}
  end
end