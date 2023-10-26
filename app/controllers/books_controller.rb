class BooksController < ApplicationController
before_action :logined_user
before_action :correct_user,only: [:edit,:update]

  def show
    @user = current_user
    @book = Book.find(params[:id])
    @book_new = Book.new
    @book_comments = @book.book_comments
    @book_comment = current_user.book_comments.new(book_id: @book.id)
    @book_detail = Book.find(params[:id])
    unless ReadCount.find_by(user_id: current_user.id,book_id: @book_detail.id)
      current_user.read_counts.create(book_id: @book_detail.id)
    end
  end

  def index
    
   to = Time.current.at_end_of_day
   from = (to - 6.day).at_beginning_of_day
   @books = Book.includes(:favorited_users).
   sort_by {|x| x.favorited_users.includes(:favorites).where(created_at: from...to).size
   }.reverse
    @book = Book.new
    
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end

  def logined_user
    unless user_signed_in?
      redirect_to new_user_session_path
  end
end

  def correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    unless @user == current_user
      redirect_to books_path
    end
  end
end
