require "securerandom"

class MessagesController < ApplicationController
  def initialize
    @message_service = MessageService.new
  end

  # GET /Messages
  def index
    render json: @message_service.get_all
  end

  # POST /Messages/application_token
  def create
    result = @message_service.create_message_in_queue(message_params)
    if result != -1
      MessageWorker.perform_async
      render json: {number: result}, status: :created
    else
      render json: {Msg: "Internal Server Error", isSuccess: false}, status: :unprocessable_entity
    end
  end

  # DELETE /messages/application_token/chat_number/message_number
  def destroy
    application_token = params[:application_token]
    chat_number = params[:chat_number]
    message_number = params[:message_number]
    result = @message_service.delete_message(application_token, chat_number, message_number)
    render json: result
  end

  # GET /messages/application_token/chat_number/message_body/search

  def search_in_message_body
    application_token = params[:application_token]
    chat_number = params[:chat_number]
    message_body = params[:message_body]
    render json: @message_service.search(application_token, chat_number, message_body)
  end

  private
    def message_params
      params.require(:message).permit(:application_token, :chat_number, :body)
    end
end
