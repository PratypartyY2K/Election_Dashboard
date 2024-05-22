class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    sort_column = params[:sort] || 'name'
    sort_direction = params[:direction] || 'asc'
    page = params[:page].presence&.to_i || 1
    puts page
    limit = params[:limit].presence&.to_i || 10
    puts limit
    offset = (page - 1) * limit
    puts offset
    @users = User.order(sort_column => sort_direction).page(page).skip(offset).per(limit)
    respond_to do |format|
      format.html 
      format.json { render json: { users: @users, meta: pagination_meta(@users) } }
    end
  end

  # GET /users/1
  def show
    @constituency = @user.belongs_to_constituency

    respond_to do |format|
      format.json { render json: { user: @user, constituency: @constituency } }
    end
  end

  # POST /users
  def create
    @user = user.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:name)
  end
end
