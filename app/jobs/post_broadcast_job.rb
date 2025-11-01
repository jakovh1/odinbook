class PostBroadcastJob < ApplicationJob
  queue_as :default

  def perform(post_id)
    post = Post.find(post_id)
    post.author.followers.find_each do |follower|
      puts follower.username
      Turbo::StreamsChannel.broadcast_prepend_later_to(
                                                        follower,
                                                        target: "posts",
                                                        partial: "posts/post",
                                                        locals: { post: post, user: follower }
                                                      )
    end
  end
end
