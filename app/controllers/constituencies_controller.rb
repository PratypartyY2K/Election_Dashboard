class ConstituenciesController < ApplicationController
  before_action :set_constituency, only: %i[ show update destroy ]

  # GET /constituencies
  def index
    sort_column = params[:sort] || 'constituency_id'
    sort_direction = params[:direction] || 'asc'
    page = params[:page] || 1
    limit = params[:limit] || 10
    @constituencies = Constituency.order(sort_column => sort_direction)
                                  .page(page)
                                  .per(limit)

    render json: @constituencies, meta: pagination_meta(@constituencies)
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
