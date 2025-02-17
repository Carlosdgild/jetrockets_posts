# frozen_string_literal: true

# RatingsController
class RatingsController < ApplicationController
  # Also could check the if user or post exists before calling the service
  # but prefered to handle everything in the service.
  # before_action: create_rating_params!, only: [create]

  def create
    result = RatePost.new(create_rating_params)
    json_response RatingAverageSerializer.new(result).as_json
  end

  private

  # Retrieve authorized params to create a rating
  # @returns ActionController::Parameters
  def create_rating_params
    params.require(:rating).permit(:post_id, :user_id, :value)
  end
end
