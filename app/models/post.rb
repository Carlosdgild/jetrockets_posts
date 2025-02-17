# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :user
  has_many :ratings, dependent: :destroy

  # Validations
  validates :title, :body, :ip, presence: true
end
