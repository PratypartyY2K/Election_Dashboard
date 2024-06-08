class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  # GET /users
  def index
    sort_column = params.dig(:columns, params.dig(:order, '0', :column).to_s, :data) || 'name'
    sort_direction = params.dig(:order, '0', :dir) || 'asc'
    page = params[:start].to_i / (params[:length].to_i + 1)
    limit = params[:length].to_i

    filters = {}
    search_columns = { '0' => :name, '1' => :gender, '2' => :constituency_id }

    search_columns.each do |index, field|
      search_value = params.dig(:columns, index, :search, :value)
      next if search_value.blank?

      filters[field] = if field == :name
                         /#{search_value}/i
                       else
                         field == :constituency_id ? search_value.to_i : search_value
                       end
    end

    @users = User.where(filters).order_by(sort_column => sort_direction).page(page).per(limit)

    total_records = User.count
    respond_to do |format|
      format.html
      format.json do
        render json: {
          users: @users,
          meta: pagination_meta(@users),
          total_records:
        }
      end
    end
  end

  # send all distinct gender in User model
  def gender_options
    genders = User.distinct(:gender)
    render json: genders
  end

  def new
    @user = User.new
  end

  # GET /users/1
  def show
    @user = set_user
    constituency_id = @user.constituency_id
    @voters = Constituency.find_by(constituency_id:)&.voters || 0
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { user: @user, voter_count: @voters } }
    end
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User was created successfully.'
      redirect_to @user
    else
      render 'new', status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    constituency_id = user_params[:constituency_id]
    if Constituency.find_by(constituency_id: constituency_id.to_i).present?
      if @user.update(user_params)
        flash[:notice] = 'User was updated successfully.'
        redirect_to @user
      else
        flash[:alert] = 'There was an error updating the user.'
        render :edit
      end
    else
      flash[:alert] = 'Invalid constituency ID.'
      render :edit
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    flash[:notice] = 'User was deleted successfully.'
    redirect_to users_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.require(:user).permit(:id, :name, :gender, :constituency_id)
  end
end
