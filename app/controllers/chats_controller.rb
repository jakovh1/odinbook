class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show edit update destroy ]

  # GET /chats or /chats.json
  def index
    @participations = Chat.chats_and_recipients(current_user)
  end

  # GET /chats/1 or /chats/1.json
  def show
    @chat = Chat.find(params[:id])
    return nil unless @chat

    @recipient = Chat.find_recipient(@chat, current_user)
    @messages = @chat.messages
    @message = @chat.messages.build
    @participations = nil

    unless request.referer == "http://localhost:3000/chats"

      @participations = Chat.chats_and_recipients(current_user)
      render :index
    end
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats or /chats.json
  def create
    begin
      @recipient = User.find(params[:recipient_id])

      ActiveRecord::Base.transaction do
        @chat = Chat.create!
        @chat.chat_participations.create!(participant: @recipient)
        @chat.chat_participations.create!(participant: current_user)
        @message = @chat.messages.build
      end

      redirect_to @chat

    rescue StandardError => e
      Rails.logger.error("Notification creation failed: #{e.class} - #{e.message}")
    end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to @chat, notice: "Chat was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat.destroy!

    respond_to do |format|
      format.html { redirect_to chats_path, notice: "Chat was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.fetch(:chat, {})
    end
end
