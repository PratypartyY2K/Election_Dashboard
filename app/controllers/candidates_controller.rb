class CandidatesController < ApplicationController
  before_action :set_candidate, only: %i[ show update destroy ]

  # GET /candidates
  def index
    sort_column = params[:sort] || 'candidate_name'
    sort_direction = params[:direction] || 'asc'
    page = params[:page] || 1
    limit = params[:limit] || 10
    @candidates = Candidate.order(sort_column => sort_direction)
                           .page(page)
                           .per(limit)

    # Fetch party names for the candidates in one query
    party_ids = @candidates.pluck(:party_id)
    parties = Party.where(party_id: { '$in': party_ids }).pluck(:party)

    # Fetch constituency names for the candidates in one query
    constituency_ids = @candidates.pluck(:constituency_id)
    constituencies = Constituency.where(constituency_id: { '$in': constituency_ids }).pluck(:constituency_name)

    # Prepare response
    candidates_with_associations = @candidates.map do |candidate|
      {
        candidate_name: candidate.candidate_name,
        belongs_to_party: parties,
        contested_from_constituency: constituencies
      }
    end

    render json: { candidates: candidates_with_associations }, meta: pagination_meta(@candidates)
  end

  # GET /candidates/1
  def show
    render json: @candidate
  end

  # POST /candidates
  def create
    @candidate = candidate.new(candidate_params)

    if @candidate.save
      render json: @candidate, status: :created, location: @candidate
    else
      render json: @candidate.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /candidates/1
  def update
    if @candidate.update(candidate_params)
      render json: @candidate
    else
      render json: @candidate.errors, status: :unprocessable_entity
    end
  end

  # DELETE /candidates/1
  def destroy
    @candidate.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate
    @candidate = Candidate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def candidate_params
    params.require(:candidate).permit(:name)
  end
end
