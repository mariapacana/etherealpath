require "rails_helper"

RSpec.describe Mission, :type => :model do
  describe "#initialize" do
    it { should validate_presence_of(:title)}
    it { should validate_presence_of(:description)}
    it { should have_many(:challenges)}
  end
end