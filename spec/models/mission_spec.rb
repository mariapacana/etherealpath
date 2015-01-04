require "rails_helper"

RSpec.describe Mission, :type => :model do
  describe "#initialize" do
    it { should have_many(:challenges)}
    it { should have_many(:participants)}
    it { should validate_presence_of(:title)}
    it { should validate_presence_of(:description)}
  end
end