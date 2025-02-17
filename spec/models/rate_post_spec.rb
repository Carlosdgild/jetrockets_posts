# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatePost, type: :model do
  subject { described_class.new(post_id: post.id, user_id: user.id, value: rating_value) }

  let(:user) { create(:user) }
  let(:post) { create(:post) }
  let(:rating_value) { 4 }

  describe '#initialize' do
    it 'initializes with user and post' do
      expect(subject.user).to eq(user)
      expect(subject.post).to eq(post)
    end

    it 'when missing all params' do
      expect do
        described_class.new({})
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'when missing user id' do
      expect do
        described_class.new({ user_id: 10 })
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'when missing post id' do
      expect do
        described_class.new({ post_id: 10 })
      end.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'when missing value' do
      expect do
        described_class.new({ user_id: user.id, post_id: post.id })
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#perform!' do
    context 'when rating does not exist' do
      it 'creates a new rating' do
        result = nil
        expect do
          result = described_class.new(post_id: post.id, user_id: user.id, value: rating_value)
        end.to change(Rating, :count).by(1)
        expect(result.rating_average).to be_a(Float)
      end
    end

    context 'when rating already exists' do
      before do
        create(:rating, post: post, user: user, value: rating_value)
      end

      it 'does not create a new rating' do
        expect do
          described_class.new(post_id: post.id, user_id: user.id, value: rating_value)
        end.not_to(change(Rating, :count))
      end

      it 'finds the existing rating' do
        rating = Rating.find_by(post: post, user_id: user.id)
        expect(subject.send(:create_or_find_rating)).to eq(rating)
      end

      it 'calculates the average rating correctly' do
        avg = Rating.average_rating_post(post.id)
        expect(subject.rating_average).to eq(avg)
      end
    end
  end

  describe '#create_or_find_rating' do
    it 'creates a rating if it does not exist' do
      expect { subject.send(:create_or_find_rating) }.to change(Rating, :count).by(1)
    end

    it 'finds the existing rating if it already exists' do
      create(:rating, post: post, user: user, value: rating_value)
      existing_rating = Rating.find_by(post: post, user: user)
      expect(subject.send(:create_or_find_rating)).to eq(existing_rating)
    end
  end

  describe '#calculate_avg_post_rating' do
    before do
      create(:rating, post: post, user: user, value: 3)
      create(:rating, post: post, user: create(:user), value: 5)
    end

    it 'calculates the average rating for the post' do
      avg = Rating.average_rating_post(post.id)
      expect(subject.send(:calculate_avg_post_rating)).to eq(avg)
    end
  end

  describe 'transaction' do
    it 'executes the rating creation and average calculation within a transaction' do
      expect { subject.send(:create_or_find_rating) }.to change(Rating, :count).by(1)
      expect(subject.rating_average).to eq(subject.send(:calculate_avg_post_rating))
    end
  end
end
