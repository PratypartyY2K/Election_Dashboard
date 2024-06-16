class ConstituenciesController < ApplicationController
  before_action :set_constituency, only: %i[show destroy]

  # GET /constituencies
  def index
    sort_column = params.dig(:columns, params.dig(:order, '0', :column).to_s, :data) || 'constituency_id'
    sort_direction = params.dig(:order, '0', :dir) || 'desc'
    page = params[:start].to_i / (params[:length].to_i + 1)
    limit = params[:length].to_i

    filters = {}
    search_columns = { '0' => :constituency_id, '1' => :constituency_name, '2' => :constituency_type }

    search_columns.each do |index, field|
      search_value = params.dig(:columns, index, :search, :value)
      next if search_value.blank?

      filters[field] = if field == :constituency_name
                         /#{search_value}/i
                       else
                         field == :constituency_id ? search_value.to_i : search_value
                       end
    end

    @constituencies = Constituency.where(filters).order_by("#{sort_column} #{sort_direction}").page(page).per(limit)
    total_records = Constituency.count
    total_voters = Constituency.voter_count_filtered(filters)
    total_candidate_count = Constituency.candidate_count_filtered(filters)
    respond_to do |format|
      format.html
      format.json do
        render json: { constituencies: @constituencies, meta: pagination_meta(@constituencies), total_records:,
                       total_voters:, total_candidate_count: }
      end
    end
  end

  # Collect distinct constituency_types in Constituency Model
  def type_options
    ct = Constituency.distinct(:constituency_type)
    render json: ct
  end

  # GET /constituencies/1
  def show
    @constituency = set_constituency
    constituency_id = @constituency.constituency_id.to_i
    @distinct_party_count = Constituency.distinct_party_count(constituency_id)
    @candidates = Candidate.find_by_constituency(constituency_id)
    respond_to do |format|
      format.html
      format.json do
        render json: { constituency: @constituency, partyCount: @distinct_party_count, candidates: @candidates }
      end
    end
  end

  # DELETE /constituencies/1
  def destroy
    @constituency.destroy
    flash[:notice] = 'Constituency was deleted successfully.'
    redirect_to constituencies_path
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
