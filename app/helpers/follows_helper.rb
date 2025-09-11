module FollowsHelper
  def follow_button_text(follow_object)
    return "Follow" unless follow_object
    follow_object.status == "pending" ? "Pending" : "Following"
  end
end
