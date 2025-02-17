# frozen_string_literal: true

# +PostCreateSerializer+ Serializer
class PostCreateSerializer < ActiveModel::Serializer
  attributes :id,
             :title,
             :body,
             :ip,
             :user

  def user
    object_user = object.user
    return if object_user.nil?

    # in order to select what attributes to retrieve, I could also set belongs_to :user
    # but wanted to do it this way for the test
    UserSimplifiedSerializer.new(object_user).as_json
  end
end
