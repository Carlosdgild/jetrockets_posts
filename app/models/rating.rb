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
end
