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
    @messages = @chat.ordered_messages
    @message = @chat.messages.build
    @participations = nil

    @chat.mark_as_read(current_user.id)
    unread_messages_count = current_user.unread_messages_count
    unread_messages_count_per_chat = current_user.unread_messages_count_per_chat(@chat.id)
    Turbo::StreamsChannel.broadcast_update_later_to(
                                                      current_user,
                                                      target: "message-counter",
                                                      html: unread_messages_count > 0 ? unread_messages_count : ""
                                                    )
    Turbo::StreamsChannel.broadcast_update_later_to(
                                                      current_user,
                                                      target: "message-counter-per-chat-#{@chat.id}",
                                                      html: unread_messages_count_per_chat > 0 ? unread_messages_count_per_chat : ""
                                                    )

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
    @chat.mark_as_read(current_user.id)
    unread_messages_count = current_user.unread_messages_count
    unread_messages_count_per_chat = current_user.unread_messages_count_per_chat(@chat.id)
    Turbo::StreamsChannel.broadcast_update_later_to(
                                                      current_user,
                                                      target: "message-counter",
                                                      html: unread_messages_count > 0 ? unread_messages_count : ""
                                                    )
    Turbo::StreamsChannel.broadcast_update_later_to(
                                                      current_user,
                                                      target: "message-counter-per-chat-#{@chat.id}",
                                                      html: unread_messages_count_per_chat > 0 ? unread_messages_count_per_chat : ""
                                                    )
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
