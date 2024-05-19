class ConstituencyController < ApplicationController
  before_action :set_constituency, only: %i[ show update destroy ]

  # GET /constituencies
  def index
    @constituencies = Constituency.all

    render json: @constituencies
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
