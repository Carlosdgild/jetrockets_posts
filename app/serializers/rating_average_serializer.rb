# frozen_string_literal: true

# +RatingAverageSerializer+
class RatingAverageSerializer < ActiveModel::Serializer
  attributes :post_id, :rating_average
end
