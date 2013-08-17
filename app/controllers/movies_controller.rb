class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction, :filter_ratings

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings # ['G','PG','PG-13','R']

    logger.debug params
    logger.debug session

    if (params[:sort].nil? and session[:sort]) or
       (params[:direction].nil? and session[:direction]) or
       (params[:ratings].nil? and session[:ratings]) then
      params[:sort] = session[:sort] if params[:sort].nil?
      params[:direction] = session[:direction] if params[:direction].nil?
      params[:ratings] = session[:ratings] if params[:ratings].nil?
      redirect_to params
    end

    @movies = Movie.where(["rating IN (?)", filter_ratings])
                   .order(sort_column + " " + sort_direction)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private

  def sort_column
    if Movie.column_names.include?(params[:sort])
      session[:sort] = params[:sort]
      params[:sort]
    else
      "title"
    end
  end

  def sort_direction
    if %w[asc desc].include?(params[:direction])
      session[:direction] = params[:direction]
      params[:direction]
    else
      "asc"
    end
  end

  def filter_ratings
    if params[:ratings]
      session[:ratings] = params[:ratings]
      ratings = params[:ratings].keys
    else
      ratings = @all_ratings
    end
  end
end
