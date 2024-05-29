class CandidatesController < ApplicationController
  before_action :set_candidate, only: %i[ show update destroy ]

  # GET /candidates
  def index
    # sort_column = params[:sort] || 'candidate_name'
    # sort_direction = params[:direction] || 'asc'
    # page = params[:page] || 1
    # limit = params[:limit] || 10
    # @candidates = Candidate.order(sort_column => sort_direction)
    #                        .page(page)
    #                        .per(limit)

    # # Fetch party names for the candidates in one query
    # party_ids = @candidates.pluck(:party_id)
    # parties = Party.where(party_id: { '$in': party_ids }).pluck(:party)

    # # Fetch constituency names for the candidates in one query
    # constituency_ids = @candidates.pluck(:constituency_id)
    # constituencies = Constituency.where(constituency_id: { '$in': constituency_ids }).pluck(:constituency_name)

    # # Prepare response
    # candidates_with_associations = @candidates.map do |candidate|
    #   {
    #     candidate_name: candidate.candidate_name,
    #     belongs_to_party: parties,
    #     contested_from_constituency: constituencies
    #   }
    # end

    # render json: { candidates: candidates_with_associations }, meta: pagination_meta(@candidates)
    sort_column = params.dig(:columns, params.dig(:order, '0', :column).to_s, :data) || 'candidate_name'
    sort_direction = params.dig(:order, '0', :dir) || 'asc'
    page = params[:length].to_i.nonzero? ? params[:start].to_i / params[:length].to_i + 1 : 1
    limit = params[:length].to_i.positive? ? params[:length].to_i : 10

    filters = {}
    filters[:candidate_name] = /#{params.dig(:columns, '0', :search, :value)}/i unless params.dig(:columns, '0', :search, :value).blank?
    filters[:sex] = params.dig(:columns, '1', :search, :value) unless params.dig(:columns, '1', :search, :value).blank?

    @candidates = Candidate.where(filters).order("#{sort_column} #{sort_direction}").page(page).per(limit)
    total_records = Candidate.count
    # total_records = Candidate.count
    respond_to do |format|
      format.html
      # format.json { render json: candidates_data }
      format.json { render json: { candidates: @candidates, meta: pagination_meta(@candidates), total_records: total_records } }
    end
  end

  def gender_options
    genders = Candidate.distinct(:sex)
    render json: genders
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
