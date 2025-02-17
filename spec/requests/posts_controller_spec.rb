# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'POST /posts' do
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

  describe 'GET posts/top_n_posts' do
    let!(:first_post) { create(:post, title: 'Post 1', body: 'Body 1') }
    let!(:second_post) { create(:post, title: 'Post 2', body: 'Body 2') }
    let!(:third_post) { create(:post, title: 'Post 3', body: 'Body 3') }

    before do
      create(:rating, post: first_post, value: 5)
      create(:rating, post: second_post, value: 3)
      create(:rating, post: third_post, value: 4)
    end

    context 'when requesting the top 2 posts' do
      it 'returns the top post by average rating' do
        get :top_n_posts, params: { n: 1 }
        expect(response).to have_http_status(:ok)
        json_response = json
        expect(json_response.count).to eq(1)
        expect(json_response[0]['id']).to eq(first_post.id)
        expect(json_response[0]['title']).to eq('Post 1')
        expect(json_response[0]['body']).to eq('Body 1')
      end

      it 'returns the top 2 posts by average rating' do
        get :top_n_posts, params: { n: 2 }
        expect(response).to have_http_status(:ok)
        json_response = json
        expect(json_response.count).to eq(2)
        expect(json_response[0]['title']).to eq('Post 1')
        expect(json_response[1]['title']).to eq('Post 3')
      end
    end

    context 'when the parameter is not given' do
      it 'returns bad request' do
        get :top_n_posts
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns bad request when is empty string' do
        get :top_n_posts, params: { n: '' }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'GET /posts/post_by_authors' do
    before do
      first_user = create(:user, login: 'author1')
      second_user = create(:user, login: 'author2')
      third_user = create(:user, login: 'author3')
      create(:post, user: first_user, ip: '192.168.1.1')
      create(:post, user: second_user, ip: '192.168.1.1')
      create(:post, user: third_user, ip: '192.168.1.2')
      create(:post, user: first_user, ip: '192.168.1.2')
      create(:post, user: first_user, ip: '192.168.1.3')
    end

    it 'returns IPs used by more than 1 author' do
      get :post_by_authors
      expect(response).to have_http_status(:ok)
      json_response = json
      expect(json_response.length).to eq(2)
      expect(json_response.first).to eq({ '192.168.1.1' => %w[author1 author2] })
      expect(json_response.last).to eq({ '192.168.1.2' => %w[author1 author3] })
    end

    it 'returns IPs used by more than N authors' do
      user = create(:user, login: 'author4')
      create(:post, user: user, ip: '192.168.1.1')
      get :post_by_authors, params: { n: 2 }
      expect(response).to have_http_status(:ok)
      json_response = json
      expect(json_response.length).to eq(1)
      expect(json_response.first).to eq({ '192.168.1.1' => %w[author1 author2 author4] })
    end

    it 'return empty array when nothing is found' do
      user = create(:user, login: 'author4')
      create(:post, user: user, ip: '192.168.1.1')
      get :post_by_authors, params: { n: 99 }
      expect(response).to have_http_status(:ok)
      json_response = json
      expect(json_response).to be_empty
    end
  end
end
