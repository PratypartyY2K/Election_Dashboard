class PartiesController < ApplicationController
  before_action :set_party

  # GET /parties
  def index
    sort_column = params.dig(:columns, params.dig(:order, '0', :column).to_s, :data) || 'party_id'
    sort_direction = params.dig(:order, '0', :dir) || 'desc'
    page = params[:start].to_i / (params[:length].to_i + 1)
    limit = params[:length].to_i

    filters = {}
    filters[:party_id] = params.dig(:columns, '0', :search, :value) unless params.dig(:columns, '0', :search,
                                                                                      :value).blank?
    filters[:party] = params.dig(:columns, '1', :search, :value) unless params.dig(:columns, '1', :search,
                                                                                   :value).blank?

    @parties = Party.where(filters).order_by("#{sort_column} #{sort_direction}").page(page).per(limit)
    total_records = Party.count
    respond_to do |format|
      format.html
      format.json { render json: { parties: @parties, meta: pagination_meta(@parties), total_records: } }
    end
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
