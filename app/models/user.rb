class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # User data validations
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                      length: { minimum: 3, maximum: 30 },
                      format: { with: /\A[a-zA-Z0-9_]+\z/, message: "only allows letters, numbers, and underscores" }

  validates :email, length: { minimum: 6, maximum: 254 }, format: { with: URI::MailTo::EMAIL_REGEXP, message: "invalid email address format" }
  validates :password, length: { minimum: 8 }, if: :password_required?

  # Posts and Comments associations
  has_many :posts, foreign_key: "author_id", dependent: :destroy
  has_many :comments, foreign_key: "user_id", dependent: :destroy

  # Followers - Followee associations
  has_many :users_following, foreign_key: "follower_id", class_name: "Follow", dependent: :destroy
  has_many :followees, through: :users_following, source: :followee

  has_many :users_followers, foreign_key: "followee_id", class_name: "Follow", dependent: :destroy
  has_many :followers, through: :users_followers, source: :follower

  # Like (User-Post)
  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_one_attached :image

  # Notification association
  has_many :notifications, foreign_key: "recipient_id", dependent: :destroy
  has_many :triggered_notifications, class_name: "Notification", foreign_key: "submitter_id", dependent: :destroy

  # Chat associations
  has_many :chat_participations, foreign_key: "participant_id"
  has_many :chats, through: :chat_participations

  has_many :messages, foreign_key: "author_id"

  scope :non_following_for, ->(user) { where.not(id: user.followees.select(:id)).where.not(id: user.id) }

  def to_param
    username
  end

  def create_post(param)
    return unless param.present?

    postable =
      if FastImage.type(param)
        is_url?(param) ? PhotoPost.new(image_url: param) : PhotoPost.new(image: param)
      else
        TextPost.new(content: param)
      end

    posts.create(postable: postable)
  end

  def create_follow(followee)
    return :already_exists if users_following.exists?(followee: followee)

    follow = users_following.build(followee: followee, status: "pending")
    follow.save ? follow : :error
  end

  def unread_messages_count
    Message.where(chat_id: chats.select(:id))
            .where.not(author_id: id)
            .where(is_read: false)
            .count
  end

  def unread_messages_count_per_chat(chat_id)
    Message.where(chat_id: chat_id)
           .where.not(author_id: id)
           .where(is_read: false)
           .count
  end

  def update_avatar(uploaded_file)
    if FastImage.type(uploaded_file)
      image.purge_later if image.attached?

      image.attach(uploaded_file)

      true
    else
      false
    end
  end

  def chats_and_recipients
    ChatParticipation
      .includes(:participant, chat: :messages)
      .where(chat_id: chats.select(:id))
      .where.not(participant_id: id)
      .left_joins(chat: :messages)
      .group("chat_participations.id, chats.id")
      .order(Arel.sql("COALESCE(MAX(messages.created_at), chats.created_at) DESC"))
  end


  private

  def is_url?(submitted_content)
    begin
      uri = URI.parse(submitted_content)
      uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
    rescue URI::InvalidURIError
      false
    end
  end
end
