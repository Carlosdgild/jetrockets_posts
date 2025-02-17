# frozen_string_literal: true

# CreatePostService
class CreatePostService < ApplicationService
  attr_accessor :title, :body, :login, :ip

  def call!
    user = find_or_create_user
    create_post(user)
  end

  private

  def initialize(args = {})
    args.each { |k, v| send("#{k}=", v) }
  end

  # Finds or create a user. If another process creates the user while trying
  # to create this, it will rise error.
  # @returns User
  def find_or_create_user
    User.find_or_create_by!(login: login)
  rescue ActiveRecord::RecordNotUnique
    User.find_by(login: login)
  end

  # Creates a Post with given params
  # @returns Post
  # @raise ActiveRecord::RecordInvalid
  def create_post(user)
    Post.create!(title: title, body: body, user: user, ip: ip)
  end
end
