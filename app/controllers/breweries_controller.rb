class BreweriesController < ApplicationController
  before_action :set_brewery, only: %i[show edit update destroy]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]
  before_action :ensure_that_admin, only: [:destroy]
  before_action :expire_brewery_list_cache, only: [:create, :update, :destroy]

  # GET /breweries or /breweries.json
  def index
    return if request.format.html? && fragment_exist?('brewerylist')

    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired
    @breweries = Brewery.all
  end

  # GET /breweries/1 or /breweries/1.json
  def show
  end

  def list
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries or /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: "Brewery was successfully created." }
        format.json { render :show, status: :created, location: @brewery }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1 or /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: "Brewery was successfully updated." }
        format.json { render :show, status: :ok, location: @brewery }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1 or /breweries/1.json
  def destroy
    @brewery.destroy!

    respond_to do |format|
      format.html { redirect_to breweries_path, status: :see_other, notice: "Brewery was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_activity
    puts "Toggling brewery activity status"
    brewery = Brewery.find(params[:id])
    brewery.update_attribute :active, !brewery.active

    new_status = brewery.active? ? "active" : "retired"

    redirect_to brewery, notice: "brewery activity status changed to #{new_status}"
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_brewery
    @brewery = Brewery.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def brewery_params
    # params.expect(brewery: [:name, :year, :active])
    params.require(:brewery).permit(:name, :year, :active)
  end

  def expire_brewery_list_cache
    expire_fragment('brewerylist')
  end
end
