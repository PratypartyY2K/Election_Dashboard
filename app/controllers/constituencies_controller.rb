class ConstituenciesController < ApplicationController
  before_action :set_constituency, only: %i[ show update destroy ]

  # GET /constituencies
  def index
    # sort_column = params[:sort] || 'constituency_id'
    # sort_direction = params[:direction] || 'asc'
    # page = params[:page] || 1
    # limit = params[:limit] || 10
    # @constituencies = Constituency.order(sort_column => sort_direction)
    #                               .page(page)
    #                               .per(limit)

    # render json: @constituencies, meta: pagination_meta(@constituencies)
    sort_column = params.dig(:columns, params.dig(:order, '0', :column).to_s, :data) || 'constituency_id'
    sort_direction = params.dig(:order, '0', :dir) || 'desc'
    page = params[:length].to_i.nonzero? ? params[:start].to_i / params[:length].to_i + 1 : 1
    limit = params[:length].to_i.positive? ? params[:length].to_i : 10

    filters = {}
    filters[:constituency_id] = params.dig(:columns, '0', :search, :value) unless params.dig(:columns, '0', :search, :value).blank?
    filters[:constituency_name] = params.dig(:columns, '1', :search, :value) unless params.dig(:columns, '1', :search, :value).blank?
    filters[:constituency_type] = params.dig(:columns, '2', :search, :value) unless params.dig(:columns, '2', :search, :value).blank?

    @constituencies = Constituency.where(filters).order("#{sort_column} #{sort_direction}").page(page).per(limit)
    total_records = Constituency.count
    # total_records = Constituency.count
    respond_to do |format|
      format.html
      # format.json { render json: constituencies_data }
      format.json { render json: { constituencies: @constituencies, meta: pagination_meta(@constituencies), total_records: total_records } }
    end
  end

  def type_options
    ct = Constituency.distinct(:constituency_type)
    render json: ct
  end

  # GET /constituencies/1
  def show
    render json: @constituency
  end

  # POST /constituencies
  def create
    @constituency = constituency.new(constituency_params)

    if @constituency.save
      render json: @constituency, status: :created, location: @constituency
    else
      render json: @constituency.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /constituencies/1
  def update
    if @constituency.update(constituency_params)
      render json: @constituency
    else
      render json: @constituency.errors, status: :unprocessable_entity
    end
  end

  # DELETE /constituencies/1
  def destroy
    @constituency.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_constituency
    @constituency = Constituency.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def constituency_params
    params.require(:constituency).permit(:name)
  end
end
