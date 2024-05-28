class UsersController < ApplicationController
  before_action :set_user, only: %i[ show update destroy ]

  # GET /users
  def index
    # sort_column = params[:sort] || 'name'
    # sort_direction = params[:direction] || 'asc'
    # page = params[:page].presence&.to_i || 1
    # puts page
    # limit = params[:limit].presence&.to_i || 10
    # puts limit
    # offset = (page - 1) * limit
    # puts offset
    # @users = User.order(sort_column => sort_direction).page(page).skip(offset).per(limit)
    respond_to do |format|
      format.html
      format.json { render json: users_data }
    end
  end

  def gender_options
    genders = User.distinct(:gender)
    render json: genders
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

  def users_data
    # Validate and set the sort column and direction
    # Rails.logger.debug "Parameters passed: #{params}"
    # puts params.dig(:order, '0', :column).to_i
    sort_column = params.dig(:columns, params.dig(:order, '0', :column).to_s, :data)
    sort_direction = params.dig(:order, '0', :dir) || 'asc'

    # Rails.logger.debug "Sort Column: #{sort_column}"
    # Rails.logger.debug "Sort Direction: #{sort_direction}"

    # Ensure the sort_column is a valid attribute
    # valid_columns = %w[name gender constituency_id]
    # sort_column = 'name' unless valid_columns.include?(sort_column)

    # Log the parameters for debugging
    # Rails.logger.debug "Sort Column: #{sort_column}"
    # Rails.logger.debug "Sort Direction: #{sort_direction}"

    # Pagination parameters
    page = params[:length].to_i.nonzero? ? params[:start].to_i / params[:length].to_i + 1 : 1
    limit = params[:length].to_i.positive? ? params[:length].to_i : 10

    # Filter conditions
    filters = {}
    filters[:name] = /#{params[:columns]['0'][:search][:value]}/i unless params[:columns]['0'][:search][:value].blank?
    filters[:gender] = params[:columns]['1'][:search][:value] unless params[:columns]['1'][:search][:value].blank?
    filters[:constituency_id] = params[:columns]['2'][:search][:value].to_i unless params[:columns]['2'][:search][:value].blank?
    # Rails.logger.debug "Filters: #{filters}"

    # Fetch and sort users
    @users = User.where(filters).order(sort_column => sort_direction).page(page).per(limit)

    # Build the response
    {
      draw: params[:draw].to_i,
      recordsTotal: User.count,
      recordsFiltered: @users.total_count,
      data: @users.as_json(only: %i[name gender constituency_id])
    }
  end
end
