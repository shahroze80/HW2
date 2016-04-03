class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
  end

  def index
    sort = params[:sort_by] || session[:sort_by]
    if sort=='title'
      @title_header='hilite'  
    elsif sort == 'release_date'
      @date_header='hilite'
    end
    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
     logger.debug(@selected_ratings.keys)
    if @selected_ratings == {}
      @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.where(rating: @selected_ratings.keys).order(sort)
    logger.debug(@movies)
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    logger.debug("it attempted to update the movie")
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def render_update_view
  end

  def myupdate
    logger.debug('IT CAME TO THE RIGHT PLACE')
    logger.debug(params)
    title=params[:movie][:title]
    @movie=Movie.find_by_title(title)
    if @movie 
      redirect_to edit_movie_path(@movie)
    else
      flash[:warning] = "Movie with title #{title} was not found. Please try again."
      redirect_to movies_update_path
    end
  end

  def render_delete_view
    @all_ratings=Movie.all_ratings
  end

  def mydelete
    logger.debug("it came to right delete")
    logger.debug(params)
    if params[:commit]=='Delete Title'
      title=params[:movie][:title]
      @movie=Movie.find_by_title(title)
      if @movie 
        @movie.destroy
        flash[:notice] = "Movie '#{@movie.title}' deleted."
      else
        flash[:warning] = "Movie with title #{title} was not found. Please try again."
        redirect_to movies_delete_path
      end

    elsif params[:commit]=='Delete Ratings'
      @selected_ratings=params[:ratings].keys
      logger.debug(@selected_ratings)
      Movie.where(rating: @selected_ratings).destroy_all
      flash[:notice] = "Movie with ratings '#{@selected_ratings}' deleted."
    end
    redirect_to movies_path
  end

end