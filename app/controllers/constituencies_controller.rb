class ConstituencyController < ApplicationController
  before_action :set_candidate, only: %i[ show update destroy ]

  # GET /constituencies
  def index
    @constituencies = Constituency.all

    render json: @constituencies
  end

  # GET /constituencies/1
  def show
    render json: @candidate
  end

  # POST /constituencies
  def create
    @candidate = candidate.new(candidate_params)

    if @candidate.save
      render json: @candidate, status: :created, location: @candidate
    else
      render json: @candidate.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /constituencies/1
  def update
    if @candidate.update(candidate_params)
      render json: @candidate
    else
      render json: @candidate.errors, status: :unprocessable_entity
    end
  end

  # DELETE /constituencies/1
  def destroy
    @candidate.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate
    @candidate = Constituency.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def candidate_params
    params.require(:candidate).permit(:name)
  end
end
