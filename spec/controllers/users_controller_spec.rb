# spec/controllers/users_controller_spec.rb
require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:constituency) { Constituency.create(constituency_id: 1, voters: 1000) }
  let(:valid_attributes) { { name: 'Test User', gender: 'Male', constituency_id: 1 } }
  let(:invalid_attributes) { { name: nil, gender: nil, constituency_id: nil } }

  describe 'GET #show' do
    let(:user) { User.create(valid_attributes) }
    it 'returns the user and voter count' do
      get :show, params: { id: user.id }

      expect(response).to have_http_status(:success)
      expect(assigns(:user)).to eq(user)
      expect(assigns(:voters)).to eq(constituency.voters)
    end

    it 'returns a success response' do
      get :show, params: { id: user.to_param }
      expect(response).to be_successful
    end

    it 'assigns the requested user as @user' do
      get :show, params: { id: user.to_param }
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new User' do
        expect do
          post :create, params: { user: valid_attributes }
        end.to change(User, :count).by(1)
      end

      it 'redirects to the created user' do
        post :create, params: { user: valid_attributes }
        expect(response).to redirect_to(User.last)
      end
    end

    context 'with invalid params' do
      it 'does not create a new User' do
        expect do
          post :create, params: { user: invalid_attributes }
        end.to_not change(User, :count)
      end

      it "renders the 'new' template" do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template('new')
      end
    end
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    # Add more tests as needed for pagination, sorting, and filtering
  end

  describe 'GET #edit' do
    let(:user) { User.create(valid_attributes) }

    it 'returns a success response' do
      get :edit, params: { id: user.to_param }
      expect(response).to be_successful
    end
  end
end
