class ChallengesController < ApplicationController

  def index
    @challenges = Challenge.current.sort_by {|c| c.current_participants.count }.reverse
  end

end