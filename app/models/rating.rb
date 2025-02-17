# frozen_string_literal: true

# Rating model
class Rating < ApplicationRecord
  acts_as_paranoid

  # Associations
  belongs_to :post
  belongs_to :user

  # Validations
  validates :value, inclusion:
    { in: 1..5, message: I18n.t('activerecord.errors.models.rating.attributes.value.inclusion') }

  validates :post_id,
            uniqueness: { scope: :user_id,
                          message: I18n.t('activerecord.errors.models.rating.attributes.value.already_voted') }

  # Finds the average in value for the given post
  # @returns Float
  def self.average_rating_post(post_id)
    where(post_id: post_id).average(:value).to_f.round(2)
  end
end
