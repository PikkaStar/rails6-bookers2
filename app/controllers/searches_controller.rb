class SearchesController < ApplicationController
  before_action :authenticate_user!
  def search
    @range = params[:range]
    if @range == "User"
      @users = User.looks(params[:search],params[:word])
      @keyword = params[:word]
     
    else
      @books = Book.looks(params[:searched],params[:word])
      @keyword = params[:word]
      
    end
  end

end
