class RatingsController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index]

  def index
    @ratings = Rating.all
    # binding.pry
    @recent_ratings = if params[:show_all] == 'true'
                        Rating.recent
                      else
                        Rating.recent.limit(5)
                      end
    @best_beers = Beer.best_rated
    @best_breweries = Brewery.best_rated
    @top_raters = User.top_raters(5)
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_back fallback_location: ratings_path,
                  notice: "Rating deleted."
  end
end
