json.extract! message, :id, :content, :author_id, :chat_id, :created_at, :updated_at
json.url message_url(message, format: :json)
