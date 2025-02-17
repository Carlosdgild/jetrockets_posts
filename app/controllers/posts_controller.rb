# frozen_string_literal: true

# PostsController
class PostsController < ApplicationController

  # Creates a new post with the given params
  # @example
  # {
  #   "id"=>437, "title"=>"New Post", "body"=>"Post content",
  #   "ip"=>"192.168.0.1",
  #   "user"=>{
  #     "id"=>854, "login"=>"user123"
  #   }
  # }
  def create
    result = CreatePostService.call!(create_post_params)
    json_response result, :created, serializer: PostCreateSerializer
  end


  # Retrieves N top post that have been rated. If a post has no rating, it will not be returned
  # @example
  # [{"id"=>413, "title"=>"Post 1", "body"=>"Body 1"}]
  def top_n_posts
    # It can also validates if required N post is lesser or equal than Post.count
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
