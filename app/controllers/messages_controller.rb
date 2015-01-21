class MessagesController < ApplicationController

  def message_params
    params.require(:message).permit(:text, :incoming)
  end

  def index
    @participant = Participant.find(params[:participant_id])
    @participant_help_button_text = @participant.needs_help ? 'Unflag' : 'Flag'
    @participant_help_button_status = @participant.needs_help ? 'help_button_active' : 'help_button_inactive'
    @messages = @participant.message_history
  end

  def create
    new_params = message_params
    new_params["incoming"] = false
    new_params["participant_id"] = params[:participant_id]
    @message = Message.new(new_params)

    respond_to do |format|
      if @message.save
        Rails.env.development? ? @message.send_by_sms : @message.delay.send_by_sms
        format.js {} #to call create.js and prepend partial
        format.json { render json: @message, status: :created, location: @participant_message }
      else
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

end