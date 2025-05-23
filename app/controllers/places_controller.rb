class PlacesController < ApplicationController
  def index
  end

  def search
    if params[:city].blank?
      redirect_to places_path, notice: "City cannot be blank."
    else
      session[:city] = params[:city]
      @places = BeermappingApi.places_in(params[:city])
      if @places.empty?
        redirect_to places_path, notice: "No locations in #{params[:city]}"
      else
        render :index, status: 418
      end
    end
  end

  def show
    @city = session[:city]
    places = BeermappingApi.places_in(@city)
    @place = places.find { |p| p.id.to_s == params[:id] }
  end
end
