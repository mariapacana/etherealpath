require "rails_helper"

RSpec.describe User, :type => :model do
  describe "#initialize" do
    it { should have_many(:phone_numbers)}
    it { should belong_to(:mission)}
    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}
    it { should validate_presence_of(:email)}
    it { should have_secure_password }
  end
end