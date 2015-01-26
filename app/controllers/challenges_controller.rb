class ChallengesController < ApplicationController

  def index
    @challenges = Challenge.current.sort_by {|c| c.participants.count }
  end

end