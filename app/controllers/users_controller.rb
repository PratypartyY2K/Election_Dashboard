class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]

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
    # total_records = User.count
    respond_to do |format|
      format.html
      # format.json { render json: users_data }
      # .map { |user| user.as_json.merge(link: user_path(user)) }
      format.json do
        render json: {
          users: @users,
          meta: pagination_meta(@users),
          total_records:
        }
      end
    end
  end

  def gender_options
    genders = User.distinct(:gender)
    render json: genders
  end

  def new
    @user = User.new
  end

  # GET /users/1
  def show
    constituency_id = set_user.constituency_id
    # Rails.logger.debug "constituency_id #{constituency_id}"
    @voters = Constituency.find_by(constituency_id:)&.voters || 0
    # Rails.logger.debug "voter count #{@voters}"
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
      # render json: @user, status: :created, location: @user
    else
      render 'new', status: :unprocessable_identity
    end
  end

  # PATCH/PUT /users/1
  def update
    # puts "user_params = #{user_params}"
    # puts @user
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

  def users_data
    # Validate and set the sort column and direction
    # Rails.logger.debug "Parameters passed: #{params}"
    # puts params.dig(:order, '0', :column).to_i
    # sort_column = params.dig(:columns, params.dig(:order, '0', :column).to_s, :data)
    # sort_direction = params.dig(:order, '0', :dir) || 'asc'

    # Rails.logger.debug "Sort Column: #{sort_column}"
    # Rails.logger.debug "Sort Direction: #{sort_direction}"

    # Ensure the sort_column is a valid attribute
    # valid_columns = %w[name gender constituency_id]
    # sort_column = 'name' unless valid_columns.include?(sort_column)

    # Log the parameters for debugging
    # Rails.logger.debug "Sort Column: #{sort_column}"
    # Rails.logger.debug "Sort Direction: #{sort_direction}"

    # Pagination parameters
    # page = params[:length].to_i.nonzero? ? params[:start].to_i / params[:length].to_i + 1 : 1
    # limit = params[:length].to_i.positive? ? params[:length].to_i : 10

    # Filter conditions
    # filters = {}
    # filters[:name] = /#{params.dig(:columns, '0', :search, :value)}/i unless params.dig(:columns, '0', :search, :value).blank?
    # filters[:gender] = params.dig(:columns, '1', :search, :value) unless params.dig(:columns, '1', :search, :value).blank?
    # filters[:constituency_id] = params.dig(:columns, '2', :search, :value).to_i unless params.dig(:columns, '2', :search, :value).blank?
    # Rails.logger.debug "Filters: #{filters}"

    # Fetch and sort users
    # @users = User.where(filters).order("#{sort_column} #{sort_direction}").page(page).per(limit)

    # Build the response
    # {
    #   draw: params[:draw].to_i,
    #   recordsTotal: User.count,
    #   recordsFiltered: @users.total_count,
    #   data: @users.as_json(only: %i[name gender constituency_id])
    # }
  end
end
