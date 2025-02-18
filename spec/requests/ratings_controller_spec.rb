# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RatingsController, type: :controller do
  describe 'POST #/v1/create' do
    let(:post_record) { create(:post) }
    let(:user) { create(:user) }
    let(:params) do
      {
        post_id: post_record.id,
        user_id: user.id,
        value: 4

      }
    end

    context 'when the parameters are valid' do
      it 'creates a new rating and returns the rating average' do
        post :create, params: { rating: params }
        response_json = json
        # status code expectations
        expect(response).to have_http_status(:ok)
        expect(response_json['post_id']).to eq(post_record.id.to_s)
        expect(response_json['rating_average'].to_f).to eq(4.0)
        expect(Rating.count).to eq(1)
        rating = Rating.last
        expect(rating.post_id).to eq(post_record.id)
        expect(rating.user_id).to eq(user.id)
        expect(rating.value).to eq(params[:value])
      end

      it 'when another process created the record' do
        Rating.create(post: post_record, user: user, value: 4)
        allow(Rating).to receive(:create!).and_raise(ActiveRecord::RecordNotUnique)
        expect(Rating).to receive(:find_by).and_call_original
        post :create, params: { rating: params }
        response_json = json
        # status code expectations
        expect(response).to have_http_status(:ok)
        expect(response_json['post_id']).to eq(post_record.id.to_s)
        expect(response_json['rating_average'].to_f).to eq(4.0)
        expect(Rating.count).to eq(1)
        rating = Rating.last
        expect(rating.post_id).to eq(post_record.id)
        expect(rating.user_id).to eq(user.id)
        expect(rating.value).to eq(params[:value])
      end
    end

    context 'when the parameters are invalid' do
      it 'returns validation errors when missing user_id' do
        params[:user_id] = nil
        post :create, params: { rating: params }
        # status code expectations
        expect(response).to have_http_status(:not_found)
        expect(json['message']).to eq('User or post does not exist')
        expect(Rating.count).to eq(0)
      end

      it 'returns validation errors when missing post_id' do
        params[:post_id] = nil
        post :create, params: { rating: params }
        # status code expectations
        expect(response).to have_http_status(:not_found)
        expect(json['message']).to eq('User or post does not exist')
        expect(Rating.count).to eq(0)
      end

      it 'returns validation errors when missing value' do
        params[:value] = nil
        post :create, params: { rating: params }
        # status code expectations
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json['message']).to eq('Validation failed: Value must be between 1 and 5')
        expect(Rating.count).to eq(0)
      end

      it 'when user_id not in the database' do
        params[:user_id] = 9999
        post :create, params: { rating: params }
        # status code expectations
        expect(response).to have_http_status(:not_found)
        expect(json['message']).to eq('User or post does not exist')
        expect(Rating.count).to eq(0)
      end

      it 'when post_id not in the database' do
        params[:post_id] = 9999
        post :create, params: { rating: params }
        # status code expectations
        expect(response).to have_http_status(:not_found)
        expect(json['message']).to eq('User or post does not exist')
        expect(Rating.count).to eq(0)
      end
    end
  end
end
