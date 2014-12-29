require "rails_helper"

RSpec.describe User, :type => :model do
  describe "#initialize" do
    puts User
    it { should belong_to(:missions)}
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}
    it { should validate_presence_of(:email)}
    it { should have_many(:phone_numbers)}
  end
end