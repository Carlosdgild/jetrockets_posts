# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'POST /users' do
    context 'with given params' do
      it 'creates a user' do
        post :create, params: { user: { login: 'login' } }
        # status code expectations
        expect(response).to have_http_status(:created)
        expect(User.last.login).to eq('login')
      end

      it 'bad request when user has same login' do
        create :user, login: 'login'
        expect do
          post :create, params: { user: { login: 'login' } }
        end.not_to change(User, :count)
        # status code expectations
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    context 'when no given params' do
      it 'bad request when login is nil' do
        expect do
          post :create, params: { user: { login: nil } }
        end.not_to change(User, :count)
        # status code expectations
        expect(response).to have_http_status(:unprocessable_content)
      end

      it 'bad request when no login provided' do
        expect do
          post :create
        end.not_to change(User, :count)
        # status code expectations
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
