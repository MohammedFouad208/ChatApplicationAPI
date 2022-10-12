require "securerandom"

class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show, :update, :destroy]

  def initialize
    @application_service = ApplicationService.new
  end

  # GET /applications
  def index
    render json: @application_service.get_all
  end

  # GET /applications/token
  def show
    render json: {name: @application.name, 
      chats_count: @application.chats_count, 
      created_at: @application.created_at,
      updated_at: @application.updated_at
    }
  end

  # POST /applications
  def create
    application = Application.new(application_params)

    if @application_service.create_application(application)
      render json: { name: application.name, token: application.token, chats_count: application.chats_count }, status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/token
  def update
    if @application_service.update_application(@application, application_params)
      render json:{ name: @application.name, token: @application.token, chats_count: @application.chats_count }
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/token
  def destroy
    result = @application_service.delete_application(@application)
    render json: result
  end

  #GET /applications/application_token/chats
  def getChats
    @chats = @application_service.get_application_chats(params[:application_token])
    render json: @chats 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = @application_service.get_application(params[:token])
    end

    # Only allow a trusted parameter "white list" through.
    def application_params
      params.require(:application).permit(:name)
    end
end
