# frozen_string_literal: true

# +TopNPostsSerializer+ Serializer
class TopNPostsSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :body
end
