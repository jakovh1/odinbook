class ChatsController < ApplicationController
  # GET /chats or /chats.json
  def index
    @chat_participations = current_user.chats_and_recipients
    puts @chat_participations.inspect
  end

  # GET /chats/1 or /chats/1.json
  def show
    @chat = Chat.find_by!(uuid: params[:uuid])

    @recipient = @chat.find_other_recipient(current_user.id)
    @messages = @chat.ordered_messages
    @message = @chat.messages.build

    @chat.mark_as_read(current_user.id)

    UpdateMessageCountJob.perform_later(user_id: current_user.id, chat_id: @chat.id)

    unless URI(request.referer).path == chats_path

      @chat_participations = current_user.chats_and_recipients
      render :index
    end
  end

  # POST /chats or /chats.json
  def create
    recipient = User.find(params[:recipient_id])

    chat = Chat.create_chat!(recipient, current_user)

    redirect_to chat
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    chat = Chat.find_by!(uuid: params[:uuid])
    chat.mark_as_read(current_user.id)
    UpdateMessageCountJob.perform_later(user_id: current_user.id, chat_id: chat.id)
  end
end
