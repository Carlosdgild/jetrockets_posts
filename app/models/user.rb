# frozen_string_literal: true

# User model
class User < ApplicationRecord
  acts_as_paranoid

  # Associations
  has_many :ratings, dependent: :destroy
  has_many :posts, dependent: :destroy

  # Validations
  validates :login, presence: true, uniqueness: true
end
