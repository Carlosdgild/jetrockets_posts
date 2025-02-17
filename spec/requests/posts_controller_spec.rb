# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'POST #/v1/create' do
    let(:params) do
      { title: 'New Post', body: 'Post content', login: 'user123', ip: '192.168.0.1' }
    end

    context 'when valid parameters are provided' do
      context 'when user with that login does not exists in the database' do
        it 'creates a new post and returns serialized post with user data' do
          post :create, params: { post: params }
          # status code expectations
          expect(response).to have_http_status(:created)
          json_response = json
          # Post attr
          expect(json_response['id']).to be_present
          expect(json_response['title']).to eq('New Post')
          expect(json_response['body']).to eq('Post content')
          expect(json_response['ip']).to eq('192.168.0.1')
          expect(json_response['user']).to be_present
          # User attr
          expect(json_response['user']['login']).to eq('user123')
        end

        it 'when tries to create a new user but it is already created' do
          user = create :user
          params[:login] = user.login
          allow(User).to receive(:find_or_create_by!).and_raise(ActiveRecord::RecordNotUnique)
          expect(User).to receive(:find_by).with(login: params[:login]).and_call_original
          post :create, params: { post: params }
          # status code expectations
          expect(response).to have_http_status(:created)
          json_response = json
          # Post attr
          expect(json_response['id']).to be_present
          expect(json_response['title']).to eq('New Post')
          expect(json_response['body']).to eq('Post content')
          expect(json_response['ip']).to eq('192.168.0.1')
          expect(json_response['user']).to be_present
          # User attr
          expect(json_response['user']['login']).to eq(user.login)
          expect(User.count).to eq(1)
          expect(User.last.id).to eq(user.id)
        end
      end

      context 'when user already exists in database' do
        let!(:user) { create(:user) }

        before { params[:login] = user.login }

        it 'creates a new post with a existing user' do
          post :create, params: { post: params }
          # status code expectations
          expect(response).to have_http_status(:created)
          json_response = json
          # Post attr
          expect(json_response['id']).to be_present
          expect(json_response['title']).to eq('New Post')
          expect(json_response['body']).to eq('Post content')
          expect(json_response['ip']).to eq('192.168.0.1')
          expect(json_response['user']).to be_present
          # User attr
          expect(json_response['user']['login']).to eq(user.login)
          expect(User.count).to eq(1)
          expect(User.last.id).to eq(user.id)
        end
      end
    end

    context 'when invalid parameters are provided' do
      it 'when post envelop it not in params' do
        post :create, params: params
        expect(response).to have_http_status(:bad_request)
        json_response = json
        expect(json_response['message']).to eq('param is missing or the value is empty or invalid: post')
      end

      it 'returns validation errors for invalid login' do
        params[:login] = ''
        post :create, params: { post: params }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = json
        expect(json_response['message']).to eq("Validation failed: Login can't be blank")
      end

      it 'returns validation errors for invalid ip' do
        params[:ip] = ''
        post :create, params: { post: params }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = json
        expect(json_response['message']).to eq("Validation failed: Ip can't be blank")
      end

      it 'returns validation errors for invalid body and title' do
        params[:body] = ''
        params[:title] = ''
        post :create, params: { post: params }
        expect(response).to have_http_status(:unprocessable_entity)
        json_response = json
        expect(json_response['message']).to eq("Validation failed: Title can't be blank, Body can't be blank")
      end
    end
  end
end
