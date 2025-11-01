class FollowsController < ApplicationController
  before_action :set_follow, only: %i[ update destroy ]

  # POST /follows or /follows.json
  def create
    followee = User.find_by!(id: params[:followee_id])
    follow = current_user.create_follow(followee)

    case follow
    when Follow
      NotificationJob.perform_later(submitter_id: current_user.id, recipient_id: followee.id, notifiable: follow)
      ::TurboUpdater.call(
                          controller_instance: self,
                          dom_target: "follow-container-#{followee.id}",
                          partial: "users/follow_button",
                          locals: { user: followee }
                         )
    when :already_exists
      render_error_message("You are already following the #{followee.username} or already sent follow request to them.")
    when :error
      render_error_message
    end
  end

  # PATCH/PUT /follows/1 or /follows/1.json
  def update
    if @follow&.accept!
      TurboUpdater.call(
        controller_instance: self,
        dom_target: "follow_#{@follow.follower.id}",
        partial: "posts/incoming_request_state",
        locals: { request_state: "Accepted" }
      )
    else
      render_error_message("Follow request could not be accepted.")
    end
  end

  # DELETE /follows/1 or /follows/1.json
  def destroy
    return render_error_message("You are not following given user.") unless @follow

    if @follow.destroy
      if @follow.follower == current_user
        TurboUpdater.call(
                            controller_instance: self,
                            dom_target: "follow-container-#{@follow.followee_id}",
                            partial: "users/follow_button",
                            locals: { user: @follow.followee }
                         )
      else
        TurboUpdater.call(
                            controller_instance: self,
                            dom_target: "follow_#{@follow.follower.id}",
                            partial: "posts/incoming_request_state",
                            locals: { request_state: "Declined" }
                         )
      end
    else
      render_error_message
    end
  end

  private

  def set_follow
    @follow = following_exists?
  end

  def following_exists?
    Follow.find_by(follower: current_user, id: params[:id]) ||
      Follow.find_by(followee: current_user, id: params[:id])
  end

  def render_error_message(flash_message = "An error occurred, please try again.")
    flash.now[:alert] = flash_message
    TurboUpdater.call(controller_instance: self, dom_target: "toast", partial: "layouts/toast")
  end
end
