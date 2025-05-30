class BeersController < ApplicationController
  before_action :set_beer, only: %i[show edit update destroy]
  before_action :styles_and_breweries, only: [:new, :edit, :create]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]
  before_action :ensure_that_admin, only: [:destroy]
  before_action :expire_beer_list_cache, only: [:create, :update, :destroy]

  # GET /beers or /beers.json
  def index
    @order = params[:order] || 'name' # Make sure this is set correctly

    # Check if the cache exists for the current ordering
    return if request.format.html? && fragment_exist?("beerlist-#{@order}")

    @beers = Beer.includes(:brewery, :ratings)

    # Sort the beers based on the order, default to 'name' if no valid order
    @beers = case @order
             when "brewery" then @beers.sort_by { |b| b.brewery.name }
             when "style" then @beers.sort_by(&:style)
             when "rating" then @beers.sort_by(&:average_rating).reverse
             else @beers.sort_by(&:name) # Default sorting for any other case
             end
  end

  # GET /beers/1 or /beers/1.json
  def show
    @rating = Rating.new
    @rating.beer = @beer
  end

  def list
  end

  # GET /beers/new
  def new
    @beer = Beer.new
    styles_and_breweries
  end

  # GET /beers/1/edit
  def edit
    styles_and_breweries
  end

  def styles_and_breweries
    @breweries = Brewery.all
    @styles = ["Weizen", "Lager", "Pale ale", "IPA", "Porter", "Lowalcohol", "Stout", "NEIPA"]
  end

  # POST /beers or /beers.json
  def create
    @beer = Beer.new(beer_params)

    respond_to do |format|
      if @beer.save
        format.html { redirect_to beers_path, notice: "Beer was successfully created." }
        format.json { render :show, status: :created, location: @beer }
      else
        styles_and_breweries
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /beers/1 or /beers/1.json
  def update
    respond_to do |format|
      if @beer.update(beer_params)
        format.html { redirect_to @beer, notice: "Beer was successfully updated." }
        format.json { render :show, status: :ok, location: @beer }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @beer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beers/1 or /beers/1.json
  def destroy
    respond_to do |format|
      format.html { redirect_to beers_path, status: :see_other, notice: "Beer was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_beer
    @beer = Beer.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def beer_params
    params.expect(beer: [:name, :style, :brewery_id])
  end

  def expire_beer_list_cache
    %w(beerlist-name beerlist-brewery beerlist-style beerlist-rating).each do |f|
      expire_fragment("#{f}-#{@order}")
    end
  end
end
