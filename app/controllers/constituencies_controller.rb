class ConstituenciesController < ApplicationController
  before_action :set_constituency, only: %i[show destroy]

  # GET /constituencies
  def index
    sort_column = params.dig(:columns, params.dig(:order, '0', :column).to_s, :data) || 'constituency_id'
    sort_direction = params.dig(:order, '0', :dir) || 'desc'
    page = params[:start].to_i / (params[:length].to_i + 1)
    limit = params[:length].to_i

    filters = {}
    filters[:constituency_id] = params.dig(:columns, '0', :search, :value) unless params.dig(:columns, '0', :search,
                                                                                             :value).blank?
    filters[:constituency_name] = params.dig(:columns, '1', :search, :value) unless params.dig(:columns, '1', :search,
                                                                                               :value).blank?
    filters[:constituency_type] = params.dig(:columns, '2', :search, :value) unless params.dig(:columns, '2', :search,
                                                                                               :value).blank?

    @constituencies = Constituency.where(filters).order_by("#{sort_column} #{sort_direction}").page(page).per(limit)
    total_records = Constituency.count
    respond_to do |format|
      format.html
      format.json do
        render json: { constituencies: @constituencies, meta: pagination_meta(@constituencies), total_records: }
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
