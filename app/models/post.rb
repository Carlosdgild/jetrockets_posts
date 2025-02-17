# frozen_string_literal: true

# Post model
class Post < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :user
  has_many :ratings, dependent: :destroy

  # Validations
  validates :title, :body, :ip, presence: true

  # Método para calcular el promedio de ratings para un post
  def average_rating
    ratings.average(:value).to_f.round(2)
  end

  # Retrieves records values.times grouped by their id and their avg value
  # @returns ActiveRecord::Relation
  def self.retrieve_post_by_average(value)
    joins(:ratings)
      .group(:id)
      .order('AVG(ratings.value) DESC')
      .limit(value)
  end
end
