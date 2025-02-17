# frozen_string_literal: true

# UsersController
class UsersController < ApplicationController
  # Creates a User with given login
  # @example
  # {
  #   "id"=>98, "login"=>"login", "deleted_at"=>nil,
  #   "created_at"=>"2025-02-17T22:35:54.042Z",
  #   "updated_at"=>"2025-02-17T22:35:54.042Z"
  # }
  def create
    json_response User.create!(create_user_params), :created
  end

  private

  # Retrieve authorized params to create a user
  # @returns ActionController::Paramters
  def create_user_params
    params.require(:user).permit(:login)
  end
end
