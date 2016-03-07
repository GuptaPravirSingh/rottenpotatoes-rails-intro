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
       
    @sort_col= params[:sorting_criteria]
    @all_ratings = Movie.all_ratings
  
    @movies = Movie.all.order(@sort_col)
    if params[:ratings]
       session[:selected_ratings] = params[:ratings]
       #@selected_ratings=params[:ratings]
       @selected_ratings=session[:selected_ratings]
       
       @movies = Movie.where({rating:  params[:ratings].keys } ).order(@sort_col)
    else if !session[:selected_ratings]
       session[:selected_ratings] = Hash.new
       @selected_ratings=Hash.new
       @all_ratings.each do |k|
        session[:selected_ratings][k]=1
        @selected_ratings.store(k,1)
      end
    end
    
    @selected_ratings=session[:selected_ratings]
    
    
    if params[:sorting_criteria]
      session[:sorting_criteria] = params[:sorting_criteria]
    end
    
    @sort_col = params[:sorting_criteria]
    
    @movies = Movie.where({rating:  session[:selected_ratings].keys })
    
    if session[:sorting_criteria]
      @movies = @movies.order(session[:sorting_criteria])
    end

  end
    
    
   
    
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
