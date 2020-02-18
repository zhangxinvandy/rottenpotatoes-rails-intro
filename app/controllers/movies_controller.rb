class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    
    logger.debug(session.inspect)
    
    @sorting = params[:sort_by] || session[:sort_by]
    @checked_ratings = params[:ratings] || session[:ratings]
    
    if !@checked_ratings
      @checked_ratings = Hash.new
      @all_ratings.each {|r| @checked_ratings[r] = 1}
    end
    
    session[:sort_by], session[:ratings] = @sorting, @checked_ratings
    
    if params[:sort_by] != session[:sort_by] || params[:ratings] != session[:ratings]
      flash.keep
      redirect_to movies_path :sort_by => @sorting, :ratings => @checked_ratings
    end
    
    @movies = Movie.where("rating" => @checked_ratings.keys).order(@sorting)

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

end
