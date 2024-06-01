class CandidatesController < ApplicationController
  before_action :set_candidate, only: %i[show edit update destroy]

  # GET /candidates
  def index
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
    respond_to do |format|
      format.html # index.html.erb
      format.json do
        render json: { candidates: @candidates, meta: pagination_meta(@candidates), total_records: }
      end
    end
  end

  # send all disctinct gender in Candidate model
  def gender_options
    genders = Candidate.distinct(:sex)
    render json: genders
  end

  # GET /candidates/1
  def show
    party_id = set_candidate.party_id
    party_name = Party.find_by(party_id:)&.party || 'Independent candidate'
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: { candidate: @candidate, partyName: party_name } }
    end
  end

  # PATCH/PUT /candidates/1
  def update
    if @candidate.update(candidate_params)
      flash[:notice] = 'Candidate was updated successfully.'
      redirect_to @candidate
    else
      flash[:alert] = 'There was an error updating the candidate.'
      render :edit
    end
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
