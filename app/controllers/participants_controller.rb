class ParticipantsController < ApplicationController
  def index
    @challenge = Challenge.find(params[:challenge_id])
    @participants = @challenge.current_participants
  end

  def index_help
    @participants = Participant.needs_help
  end

  def update
    @participant = Participant.find(params[:id])

    respond_to do |format|
      if @participant.toggle_help
        format.json { render json: @participant, status: :ok }
      else
        format.json { render json: @participant.errors, status: :unprocessable_entity }
      end
    end
  end
end
