class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /bands
  def index
    @users = User.all

    render json: @users
  end

  # GET /bands/1
  def show
    render json: @user
  end
end
