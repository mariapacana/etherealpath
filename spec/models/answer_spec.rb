require "rails_helper"

RSpec.describe Answer, :type => :model do
  describe "#initialize" do
    it { should belong_to(:challenge)}
    it { should validate_presence_of(:text)}
  end

  describe "#matches" do
    let!(:answer) {Answer.create(text: "Whatever")}

    context "when text matches exactly" do
      it "should return true" do
        expect(answer.matches("whatever")).to be true
      end
    end

    context "when text contains answer" do
      it "should return true" do
        expect(answer.matches("  whatever  ")).to be true
      end
    end

    context "when text doesn't match at all" do
      it "should return false" do
        expect(answer.matches("argh")).to be false
      end
    end
  end
end