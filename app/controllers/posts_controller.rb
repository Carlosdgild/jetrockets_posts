# frozen_string_literal: true

# PostsController
class PostsController < ApplicationController
  def create
    result = CreatePostService.call!(create_post_params)
    json_response result, :created, serializer: PostCreateSerializer
  end

  private

  # Retrieve authorized params to create a post
  # @returns ActionController::Paramters
  def create_post_params
    params.require(:post).permit(:title, :body, :login, :ip)
    # if no given ip, could retrieve from request.remote_ip
  end
end
