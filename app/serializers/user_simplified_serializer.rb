# frozen_string_literal: true

# +UserSimplifiedSerializer+ Serializer
class UserSimplifiedSerializer < ActiveModel::Serializer
  attributes :id,
             :login
end
