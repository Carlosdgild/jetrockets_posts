# frozen_string_literal: true

# PostsController
class PostsController < ApplicationController
  def create
    result = CreatePostService.call!(create_post_params)
    json_response result, :created, serializer: PostCreateSerializer
  end

  # It can also validates if required N post is lesser or equal than Post.count
  def top_n_posts
    result = Post.retrieve_post_by_average(params.require(:n))
    json_response result, :ok, each_serializer: TopNPostsSerializer
  end

  private

  # Retrieve authorized params to create a post
  # @returns ActionController::Paramters
  def create_post_params
    params.require(:post).permit(:title, :body, :login, :ip)
    # if no given ip, could retrieve from request.remote_ip
  end
end
