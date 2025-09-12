module UsersHelper
  def gravatar_avatar_url(email)
    hash = Digest::MD5.hexdigest(email.strip.downcase)
    "https://www.gravatar.com/avatar/#{hash}?d=monsterid"
  end
end
