class CandidatesController < ApplicationController
  before_action :set_candidate, only: %i[show edit update destroy]

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
    page = params[:start].to_i / (params[:length].to_i + 1)
    limit = params[:length].to_i

    filters = {}
    filters[:candidate_name] = /#{params.dig(:columns, '0', :search, :value)}/i unless params.dig(:columns, '0',
                                                                                                  :search, :value).blank?
    filters[:sex] = params.dig(:columns, '1', :search, :value) unless params.dig(:columns, '1', :search, :value).blank?

    @candidates = Candidate.where(filters).order("#{sort_column} #{sort_direction}").page(page).per(limit)
    total_records = Candidate.count
    # total_records = Candidate.count
    respond_to do |format|
      format.html
      # format.json { render json: candidates_data }
      format.json do
        render json: { candidates: @candidates, meta: pagination_meta(@candidates), total_records: }
      end
    end
  end

  def gender_options
    genders = Candidate.distinct(:sex)
    render json: genders
  end

  # GET /candidates/1
  def show
    party_id = set_candidate.party_id
    party_name = Party.find_by(party_id:)&.party || 'Independent candidate'
    respond_to do |format|
      format.html
      format.json { render json: { candidate: @candidate, partyName: party_name } }
    end
    # render json: @candidate
  end

  # def new
  #   @candidate = Candidate.new
  # end

  # POST /candidates
  # def create
  #   constituency_id = candidate_params[:constituency_id].to_i
  #   party_id = candidate_params[:party_id].to_i
  #   # puts Constituency.find_by(constituency_id: constituency_id).present? && Party.find_by(party_id: party_id.to_i).present?
  #   if Constituency.find_by(constituency_id: constituency_id).present? && Party.find_by(party_id: party_id).present?
  #     @candidate = Candidate.new(candidate_params)

  #     if @candidate.save
  #       flash[:notice] = 'Candidate was created successfully.'
  #       redirect_to action: 'show', id: @candidate.id
  #       # render json: @candidate, status: :created, location: @candidate
  #     else
  #       flash[:alert] = 'There was an error creating a candidate.'
  #       render :new
  #     end
  #   else
  #     flash[:alert] = 'Invalid constituency ID or party ID.'
  #     render :new
  #   end
  # end

  # PATCH/PUT /candidates/1
  def update
    # constituency_id = candidate_params[:constituency_id].to_i
    # party_name = candidate_params[:party].to_i

    # if Constituency.find_by(constituency_id: constituency_id).present? && Party.find_by(party_id: party_id).present?
    if @candidate.update(candidate_params)
      flash[:notice] = 'Candidate was updated successfully.'
      redirect_to @candidate
    else
      flash[:alert] = 'There was an error updating the candidate.'
      render :edit
    end
    # else
    #   flash[:alert] = 'Invalid constituency ID or party ID.'
    #   render :edit
    # end
  end

  # DELETE /candidates/1
  def destroy
    @candidate.destroy
    flash[:notice] = 'Candidate was deleted successfully.'
    redirect_to candidates_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_candidate
    @candidate = Candidate.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def candidate_params
    params.require(:candidate).permit(:id, :candidate_name, :sex, :constituency_id, :party_id, :age)
  end
end
