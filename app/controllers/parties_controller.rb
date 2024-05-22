class PartiesController < ApplicationController
  before_action :set_party, only: %i[show update destroy]

  # GET /parties
  def index
    sort_column = params[:sort] || 'party_id'
    sort_direction = params[:direction] || 'asc'
    page = params[:page] || 1
    limit = params[:limit] || 10
    @parties = Party.order(sort_column => sort_direction)
                    .page(page)
                    .per(limit)

    # Fetch candidates for the parties in one query
    party_ids = @parties.pluck(:party_id)
    candidates = Candidate.where(party_id: { '$in': party_ids }).pluck(:candidate_name)

    # Prepare response
    parties_with_associations = @parties.map do |party|
      {
        party_name: party.party,
        candidates: candidates
      }
    end

    render json: { parties: parties_with_associations }, meta: pagination_meta(@parties)
  end

  # GET /parties/1
  def show
    @candidates = @party.all_candidates

    respond_to do |format|
      format.json { render json: { party: @party, candidates: @candidates } }
    end
  end

  # POST /parties
  def create
    @party = party.new(party_params)

    if @party.save
      render json: @party, status: :created, location: @party
    else
      render json: @party.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /parties/1
  def update
    if @party.update(party_params)
      render json: @party
    else
      render json: @party.errors, status: :unprocessable_entity
    end
  end

  # DELETE /parties/1
  def destroy
    @party.destroy!
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_party
    @party = Party.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def party_params
    params.require(:party).permit(:name, :party_id)
  end
end
