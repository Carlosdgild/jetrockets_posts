# frozen_string_literal: true

# # frozen_string_literal: true

# RatePost
class RatePost < ActiveModelSerializers::Model
  attr_accessor :post_id, :user_id, :value, :user, :post, :rating, :rating_average

  def perform!
    ActiveRecord::Base.transaction do
      self.rating = create_or_find_rating
      self.rating_average = calculate_avg_post_rating
    end
  end

  private

  def initialize(args = {})
    args.each { |k, v| send("#{k}=", v) }
    validate_user_and_post!
    perform!
  end

  # Validates if user and post exists to create a new rating
  # @returns nil
  # @raise ActiveRecord::RecordNotFound
  def validate_user_and_post!
    return if User.exists?(user_id) && Post.exists?(post_id)

    raise ActiveRecord::RecordNotFound.new('User or post does not exist')
  end

  # Finds or create a rating. If another process creates the user while trying
  # to create this, it will rise error.
  # @returns User
  def create_or_find_rating
    Rating.create!(post_id: post_id, user_id: user_id, value: value.to_i)
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid => e
    raise e if value.blank?

    Rating.find_by(post: post_id, user_id: user_id)
  end

  # Calculates the average rating of the given post
  def calculate_avg_post_rating
    Rating.average_rating_post(post_id)
  end
end
