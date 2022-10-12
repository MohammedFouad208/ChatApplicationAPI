class ChatsController < ApplicationController
  def initialize
    @chat_service = ChatService.new
  end

  # GET /chats
  def index
    render json: @chat_service.get_all
  end

  # POST /chats/application_token
  def create
    result = @chat_service.create_chat_in_queue(params[:application_token])
    if result != -1
      ChatWorker.perform_async
      render json: {number: result}, status: :created
    else
      render json: {Msg: "Internal Server Error", isSuccess: false}, status: :unprocessable_entity
    end
  end

  # DELETE /chats/application_token/chat_number
  def destroy
    application_token = params[:application_token]
    chat_number = params[:chat_number]
    result = @chat_service.delete_chat(application_token, chat_number)
    render json: result
  end

  # GET /chats/application_token/chat_number/messages
  def mgetMessages
    application_token = params[:application_token]
    chat_number = params[:chat_number]
    render json: @chat_service.get_chat_messages(application_token, chat_number)
  end
end
