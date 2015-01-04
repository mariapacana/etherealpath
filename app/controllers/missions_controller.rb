class MissionsController < ApplicationController

  def mission_params
    params.require(:mission).permit(:title, :description, challenges_attributes: [:id, :question, :answer, :_destroy])
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)
    @mission.save
    redirect_to new_mission_path
  end
end