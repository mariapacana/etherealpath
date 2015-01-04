class MissionsController < ApplicationController

  def mission_params
    params.require(:mission).permit(:title, :description, challenges_attributes: [:id, :question, :answer, :_destroy])
  end

  def new
    @mission = Mission.new
  end

  def create
    @mission = Mission.new(mission_params)
    if @mission.save
      redirect_to mission_path(@mission)
    else
      # show error message if mission is invalid
      render :new
    end
  end

  def show
    @mission = Mission.find(params[:id])
  end

  def edit
    @mission = Mission.find(params[:id])
  end

  def update
    @mission = Mission.find(params[:id])
    if @mission.update_attributes(mission_params)
      redirect_to mission_path(@mission)
    else
      # show error message if mission is invalid
      flash[:error] = @mission.errors.full_messages
      render :edit
    end
  end
end