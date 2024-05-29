class PartiesController < ApplicationController
  before_action :set_party, only: %i[show update destroy]

  # GET /parties
  def index
    # sort_column = params[:sort] || 'party_id'
    # sort_direction = params[:direction] || 'asc'
    # page = params[:page] || 1
    # limit = params[:limit] || 10
    # @parties = Party.order(sort_column => sort_direction)
    #                 .page(page)
    #                 .per(limit)

    # # Fetch parties for the parties in one query
    # party_ids = @parties.pluck(:party_id)
    # parties = Party.where(party_id: { '$in': party_ids }).pluck(:party_name)

    # # Prepare response
    # parties_with_associations = @parties.map do |party|
    #   {
    #     party_name: party.party,
    #     parties: parties
    #   }
    # end

    # render json: { parties: parties_with_associations }, meta: pagination_meta(@parties)
    sort_column = params.dig(:columns, params.dig(:order, '0', :column).to_s, :data) || 'party_id'
    sort_direction = params.dig(:order, '0', :dir) || 'desc'
    page = params[:length].to_i.nonzero? ? params[:start].to_i / params[:length].to_i + 1 : 1
    limit = params[:length].to_i.positive? ? params[:length].to_i : 10

    filters = {}
    filters[:party_id] = params.dig(:columns, '0', :search, :value) unless params.dig(:columns, '0', :search, :value).blank?
    filters[:party] = params.dig(:columns, '1', :search, :value) unless params.dig(:columns, '1', :search, :value).blank?

    @parties = Party.where(filters).order("#{sort_column} #{sort_direction}").page(page).per(limit)
    total_records = Party.count
    # total_records = Party.count
    respond_to do |format|
      format.html
      # format.json { render json: parties_data }
      format.json { render json: { parties: @parties, meta: pagination_meta(@parties), total_records: total_records } }
    end
  end

  # GET /parties/1
  def show
    @parties = @party.all_parties

    respond_to do |format|
      format.json { render json: { party: @party, parties: @parties } }
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
