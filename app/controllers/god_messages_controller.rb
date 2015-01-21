class GodMessagesController < ApplicationController

  def god_message_params
    params.require(:god_message).permit(:text, :location)
  end

  def create
    new_params = god_message_params
    new_params["mission_id"] = params[:mission_id]
    @god_message = GodMessage.new(new_params)

    respond_to do |format|
      if @god_message.save
        format.js {} #to call create.js and prepend partial
        format.json { render json: @god_message, status: :created, location: @mission_god_message }
      else
        format.json { render json: @god_message.errors, status: :unprocessable_entity }
      end
    end
  end

end